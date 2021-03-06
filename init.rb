require 'redmine'

# This plugin should be reloaded in development mode.
if RAILS_ENV == 'development'
  ActiveSupport::Dependencies.load_once_paths.reject!{|x| x =~ /^#{Regexp.escape(File.dirname(__FILE__))}/}
end

Redmine::Plugin.register :redmine_issue_reminder do
  name 'Redmine Issue Reminder plugin'
  author 'Ascendro S.R.L'
  description 'Issue reminder plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/ascendro/redmine_issue_reminder'
  author_url 'http://www.ascendro.ro/'

  permission :view_issue_reminder, :reminders => :index

  settings( :default => { 'email_subject' => :default_email_subject},
            :partial => 'reminder_settings/issue_reminder_settings')
  
  project_module :issue_reminder do
    permission :view_issue_reminder, :reminders => :index
  end

  if_proc = Proc.new{|project| project.enabled_module_names.include?('issue_reminder')}
  menu :project_menu,
    :issue_reminder,
  { :controller => "reminders", :action => "index" },
    :caption => :issues_reminder,
    :last => true,
    :param => :project_id,
    :if => if_proc
end
