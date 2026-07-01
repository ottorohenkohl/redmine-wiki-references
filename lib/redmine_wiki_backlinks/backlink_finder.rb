module RedmineWikiBacklinks
  class BacklinkFinder
    class << self
      def referencing_pages(issue, user = User.current)
        return [] if issue.nil? || issue.id.nil?

        WikiPageIssueReference
          .where(issue_id: issue.id)
          .includes(wiki_page: { wiki: :project })
          .filter_map(&:wiki_page)
          .uniq
          .select { |page| page.visible?(user) }
          .sort_by { |page| [page.project.name.downcase, page.title.downcase] }
      end
    end
  end
end
