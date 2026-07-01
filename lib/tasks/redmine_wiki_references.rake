namespace :redmine_wiki_references do
  desc 'Rebuild the wiki references index from all current wiki content'
  task reindex: :environment do
    unless WikiPageIssueReference.table_exists?
      abort 'wiki_page_issue_references table is missing. Run `rake redmine:plugins:migrate` first.'
    end

    print 'Rebuilding wiki references index... '

    RedmineWikiReferences::Indexer.reindex_all
  end
end
