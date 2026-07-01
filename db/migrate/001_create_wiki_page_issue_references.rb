class CreateWikiPageIssueReferences < ActiveRecord::Migration[6.1]
  def up
    unless table_exists?(:wiki_page_issue_references)
      create_table :wiki_page_issue_references do |t|
        t.integer :wiki_page_id, null: false
        t.integer :issue_id,     null: false
      end

      add_index :wiki_page_issue_references, %i[wiki_page_id issue_id], unique: true, name: :wiki_page_issue_refs_unique
      add_index :wiki_page_issue_references, :issue_id, name: :wiki_page_issue_refs_issue_id
    end

    if defined?(RedmineWikiReferences::Indexer)
      WikiPageIssueReference.reset_column_information
      RedmineWikiReferences::Indexer.reindex_all
    end
  end

  def down
    drop_table :wiki_page_issue_references, if_exists: true
  end
end
