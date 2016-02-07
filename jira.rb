dep 'jira', :version, :install_prefix, :home_directory do
  version.default!('7.0.3')
  install_prefix.default!('/usr/local/atlassian')
  home_directory.default!('/etc/jira')

  requires [
               'jdk',
               'atlassian.user_exists',
               'atlassian.product.installed'.with('jira', version, install_prefix, "atlassian-jira-software-#{version}-jira-#{version}.tar.gz"),
               'atlassian.product.home_directory_set'.with('jira', install_prefix, home_directory),
               'atlassian.permissions'.with(install_prefix, home_directory, 'jira', 'atlassian')
           ]
end
