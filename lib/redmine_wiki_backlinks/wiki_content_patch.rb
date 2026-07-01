module RedmineWikiBacklinks
  module WikiContentPatch
    def self.included(base)
      base.class_eval do
        after_save    :update_wiki_backlinks_index
        after_destroy :remove_wiki_backlinks_index
      end
    end

    def update_wiki_backlinks_index
      RedmineWikiBacklinks::Indexer.reindex_from_content(self)
    end

    def remove_wiki_backlinks_index
      RedmineWikiBacklinks::Indexer.remove_page(page_id)
    end
  end
end
