require 'redmine'

Redmine::Plugin.register :redmine_wiki_backlinks do
  name        'Redmine Wiki Backlinks'
  author      'Otto'
  description 'Shows, at the bottom of every issue, the wiki pages that reference it via #<id>.'
  version     '0.1.0'

  requires_redmine version_or_higher: '6.0.0'
end

unless defined?(WikiBacklinksViewHook)
  class WikiBacklinksViewHook < Redmine::Hook::ViewListener
    render_on :view_issues_show_details_bottom, partial: 'wiki_backlinks/issue_backlinks'
  end
end

unless WikiContent.included_modules.include?(RedmineWikiBacklinks::WikiContentPatch)
  WikiContent.include(RedmineWikiBacklinks::WikiContentPatch)
end
