module RedmineWikiBacklinks
  module ReferenceExtractor
    module_function

    def issue_ids(text)
      return [] if text.blank?

      text.to_s.scan(/(?<![\w&!])#(\d+)(?!\w)/).flatten.map(&:to_i).uniq
    end
  end
end
