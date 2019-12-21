require "../spec_helper"

def annotations(rule)
  source = Ameba::Source.new ""
  source.add_issue(rule, {1, 1}, "error")

  formatter = Ameba::GithubAction::Formatter.new
  formatter.source_finished(source)
  formatter.result.annotations
end

module Ameba::GithubAction
  describe Formatter do
    describe "#result" do
      it "returns an empty result" do
        result = Formatter.new.result
        result.success?.should be_true
        result.summary.total_issues.should eq 0
      end
    end

    describe "#source_finished" do
      error_rule = Ameba::Rule::Lint::Syntax.new
      warning_rule = Ameba::Rule::Lint::UnusedArgument.new
      convention_rule = Ameba::Rule::Style::RedundantReturn.new

      it "increments amount of sources" do
        formatter = Formatter.new
        formatter.source_finished(Ameba::Source.new "")
        formatter.result.summary.total_sources.should eq 1
        formatter.result.summary.total_issues.should eq 0
        formatter.result.annotations.size.should eq 0
      end

      it "increments amount of issues if any" do
        source = Ameba::Source.new ""
        source.add_issue(error_rule, {1, 1}, "error")

        formatter = Formatter.new
        formatter.source_finished(source)
        formatter.result.summary.total_sources.should eq 1
        formatter.result.summary.total_issues.should eq 1
        formatter.result.annotations.size.should eq 1
      end

      it "ignored disabled issues" do
        source = Ameba::Source.new ""
        location = Crystal::Location.new("source", 1, 1)
        end_location = Crystal::Location.new("source", 1, 2)
        source.add_issue(error_rule, location, end_location, "error", :disabled)

        formatter = Formatter.new
        formatter.source_finished(source)
        formatter.result.summary.total_sources.should eq 1
        formatter.result.summary.total_issues.should eq 0
      end

      context "annotation level" do
        it "converts error rule to failure" do
          annotations(error_rule)
            .first.annotation_level.should eq AnnotationLevel::Failure
        end

        it "converts warning rule to warning" do
          annotations(warning_rule)
            .first.annotation_level.should eq AnnotationLevel::Warning
        end

        it "converts convention rule to notice" do
          annotations(convention_rule)
            .first.annotation_level.should eq AnnotationLevel::Notice
        end
      end
    end
  end
end
