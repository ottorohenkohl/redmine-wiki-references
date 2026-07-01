module RedmineWikiReferences
  module Indexer
    module_function

    def reindex_from_content(content)
      return if content.nil?
      return if content.page_id.nil?

      ids = ReferenceExtractor.issue_ids(content.text)

      WikiPageIssueReference.transaction do
        WikiPageIssueReference.where(wiki_page_id: content.page_id).delete_all
        WikiPageIssueReference.insert_all(issue_ids.map { |iid| { wiki_page_id: page_id, issue_id: iid } })
      end
    rescue ActiveRecord::RecordNotUnique
      return
    end

    def remove_page(page_id)
      return if page_id.nil?

      WikiPageIssueReference.where(wiki_page_id: page_id).delete_all
    end

    def reindex_all
      WikiPageIssueReference.delete_all
      WikiContent.find_each(batch_size: 500) do |content|
        ids = ReferenceExtractor.issue_ids(content.text)

        next if ids.empty?

        WikiPageIssueReference.insert_all(issue_ids.map { |iid| { wiki_page_id: page_id, issue_id: iid } })
      end
    end
  end
end
