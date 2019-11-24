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
        next if issue.location.nil?

        result.summary.total_issues += 1

        result.annotations << Annotation.new(
          path: convert_path(source.path),
          title: issue.rule.name,
          start_line: issue.location.not_nil!.line_number,
          start_column: issue.location.not_nil!.column_number,
          end_line: issue.end_location.try &.line_number,
          end_column: issue.end_location.try &.column_number,
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
