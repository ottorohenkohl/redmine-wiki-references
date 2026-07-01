class WikiPageIssueReference < ActiveRecord::Base
  belongs_to :wiki_page, optional: true
  belongs_to :issue,     optional: true
end
