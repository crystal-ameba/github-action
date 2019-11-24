require "ameba"
require "./output"

module Ameba::GithubAction
  class Formatter < Ameba::Formatter::BaseFormatter
    getter result = Output.new

    def initialize(@base_dir = "./")
      super(STDOUT)
    end

    def source_finished(source : Source)
      result.summary.total_sources += 1

      source.issues.each do |issue|
        start_line = issue.location.try &.line_number
        end_line = issue.end_location.try &.line_number

        next unless start_line

        result.summary.total_issues += 1

        result.annotations << Annotation.new(
          path: convert_path(source.path),
          title: issue.rule.name,
          start_line: start_line,
          end_line: end_line || start_line,
          annotation_level: convert_severity(issue.rule.severity),
          message: issue.message
        )
      end
    end

    private def convert_severity(severity)
      case severity
      when Ameba::Severity::Error      then AnnotationLevel::Failure
      when Ameba::Severity::Warning    then AnnotationLevel::Warning
      when Ameba::Severity::Convention then AnnotationLevel::Notice
      else
        AnnotationLevel::Notice
      end
    end

    private def convert_path(path)
      path.gsub(/^#{@base_dir}/, "").gsub(/^\//, "")
    end
  end
end
