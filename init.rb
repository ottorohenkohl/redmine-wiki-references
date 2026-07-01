require 'redmine'

Redmine::Plugin.register :redmine_wiki_references do
  name        'Wiki References'
  author      'Otto'
  description 'Shows, at the bottom of every issue, the wiki pages that reference it via #<id>.'
  version     '0.1.0'

  requires_redmine version_or_higher: '6.0.0'
end

unless defined?(WikiReferencesViewHook)
  class WikiReferencesViewHook < Redmine::Hook::ViewListener
    render_on :view_issues_show_details_bottom, partial: 'wiki_references/issue_references'
  end
end

unless WikiContent.included_modules.include?(RedmineWikiReferences::WikiContentPatch)
  WikiContent.include(RedmineWikiReferences::WikiContentPatch)
end
