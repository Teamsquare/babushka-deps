dep 'jira.installed', :version, :install_prefix, :home_directory do
  version.default!('6.1.2')
  install_prefix.default!('/usr/local/atlassian')
  home_directory.default!('/etc/jira')

  requires [
               'jdk'.with(7),
               'atlassian.user_exists',
               'jira'.with(version, install_prefix),
               'jira.home_directory_set'.with(install_prefix, home_directory),
               'atlassian.permissions'.with(install_prefix, home_directory, 'jira', 'atlassian')
           ]
end

dep 'jira', :version, :install_prefix do
  setup do
    must_be_root
  end

  met? do
    "#{install_prefix}/jira/bin/startup.sh".p.exists?
  end

  meet do
    shell "mkdir -p #{install_prefix}"
    tar_file = "atlassian-jira-#{version}.tar.gz"
    shell "wget http://www.atlassian.com/software/jira/downloads/binary/#{tar_file} -P /tmp"
    shell "tar xvf /tmp/#{tar_file} -C #{install_prefix}"
    shell "mv #{install_prefix}/*jira* #{install_prefix}/jira"
    shell "rm /tmp/#{tar_file}"
  end
end

dep 'jira.home_directory_set', :install_prefix, :home_directory do
  setup do
    must_be_root
  end

  met? do
    "#{install_prefix}/jira/atlassian-jira/WEB-INF/classes/jira-application.properties".p.grep(/#{home_directory}/)
  end

  meet do
    shell "mkdir -p #{home_directory}"
    shell "echo 'jira.home=#{home_directory}' > #{install_prefix}/jira/atlassian-jira/WEB-INF/classes/jira-application.properties"
  end
end