module Ameba::GithubAction
  record Output,
    title = "Crystal Ameba Results",
    summary = Summary.new,
    annotations = [] of Annotation do
    def to_json(json)
      {title: title, summary: summary, annotations: annotations}.to_json(json)
    end

    def success?
      summary.total_issues == 0
    end
  end

  enum AnnotationLevel
    Notice
    Warning
    Failure
  end

  record Annotation,
    path : String,
    title : String,
    start_line : Int32,
    end_line : Int32,
    annotation_level : AnnotationLevel,
    message : String do
    def to_json(json)
      {
        path:             path,
        title:            title,
        start_line:       start_line,
        end_line:         end_line,
        annotation_level: annotation_level.to_s.downcase,
        message:          message,
      }.to_json(json)
    end
  end

  class Summary
    getter ameba_version : String = Ameba::VERSION
    getter crystal_version : String = Crystal::VERSION
    property total_sources = 0
    property total_issues = 0

    def to_json(json)
      json.string <<-SUMMARY
        Total files checked: *#{total_sources}*
        Issues found: *#{total_issues}*

        Ameba Version: *#{ameba_version}*
        Cystal Version: *#{crystal_version}*
      SUMMARY
    end
  end
end
