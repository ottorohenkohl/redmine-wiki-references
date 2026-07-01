module RedmineWikiReferences
  module WikiContentPatch
    def self.included(base)
      base.class_eval do
        after_save    :update_wiki_references_index
        after_destroy :remove_wiki_references_index
      end
    end

    def update_wiki_references_index
      RedmineWikiReferences::Indexer.reindex_from_content(self)
    end

    def remove_wiki_references_index
      RedmineWikiReferences::Indexer.remove_page(page_id)
    end
  end
end
