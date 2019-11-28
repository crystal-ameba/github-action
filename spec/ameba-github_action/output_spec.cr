require "../spec_helper"

module Ameba::GithubAction
  describe Output do
    describe "#to_json" do
      it "can be properly serialized" do
        subject = Output.new
        result = JSON.parse({subject: subject}.to_json)["subject"].as_h
        result["title"].as_s.should_not be_nil
        result["summary"].should_not be_nil
        result["annotations"].as_a.should be_empty
      end
    end

    describe "#success?" do
      it "returns true if there are no issues" do
        Output.new.success?.should be_true
      end

      it "returns false if there are some issues" do
        output = Output.new
        output.summary.total_issues += 1
        output.success?.should be_false
      end
    end
  end

  describe Annotation do
    describe "#to_json" do
      it "can be properly serialized" do
        subject = Annotation.new(
          path: "path",
          title: "title",
          start_line: 1,
          end_line: 3,
          annotation_level: AnnotationLevel::Notice,
          message: "message"
        )
        result = JSON.parse({subject: subject}.to_json)["subject"].as_h
        result["path"].should eq subject.path
        result["title"].should eq subject.title
        result["start_line"].should eq subject.start_line
        result["end_line"].should eq subject.end_line
        result["annotation_level"].should eq "notice"
        result["message"].should eq subject.message
      end
    end
  end

  describe Summary do
    describe "#ameba_version" do
      it "returns a correct ameba version" do
        Summary.new.ameba_version.should eq Ameba::VERSION
      end
    end

    describe "#crystal_version" do
      it "returns a correct crystal version" do
        Summary.new.crystal_version.should eq Crystal::VERSION
      end
    end

    describe "#total_sources" do
      it "defaults to 0" do
        Summary.new.total_sources.should eq 0
      end

      it "allows to set/get total_sources" do
        subject = Summary.new
        subject.total_sources = 42
        subject.total_sources.should eq 42
      end
    end

    describe "#total_issues" do
      it "defaults to 0" do
        Summary.new.total_issues.should eq 0
      end

      it "allows to set/get total_issues" do
        subject = Summary.new
        subject.total_issues = 42
        subject.total_issues.should eq 42
      end
    end

    describe "#to_json" do
      it "can be properly serialized" do
        subject = Summary.new
        subject.total_sources = 10
        subject.total_issues = 11
        result = JSON.parse({subject: subject}.to_json)["subject"].as_s
        result.should match /Total files checked: \*10\*/
        result.should match /Issues found: \*11\*/
        result.should match /Ameba Version: \*#{Ameba::VERSION}\*/
        result.should match /Crystal Version: \*#{Crystal::VERSION}\*/
      end
    end
  end
end
