dep 'jira.installed', :version, :install_prefix, :home_directory do
  version.default!('5.2')
  install_prefix.default!('/usr/local')
  home_directory.default!('/etc/jira')

  requires [
               'jre',
               'jira'.with(version, install_prefix, home_directory),
           ]
end

dep 'jira', :version, :install_prefix, :home_directory do
  setup do
    must_be_root
  end

  met? do
    "#{install_prefix}/jira/bin/startup.sh".p.exists?
  end

  meet do
    tar_file = "atlassian-jira-#{version}.tar.gz"
    shell "wget http://www.atlassian.com/software/jira/downloads/binary/#{tar_file} -P /tmp"
    shell "tar xvf /tmp/#{tar_file} -C #{install_prefix}"
    shell "mv #{install_prefix}/*jira* #{install_prefix}/jira"
    shell "rm /tmp/#{tar_file}"
    shell "mkdir -p #{home_directory}"
    shell "echo 'jira.home=#{home_directory}' > #{install_prefix}/atlassian-jira/webapp/WEB-INF/classes/jira-application.properties"
  end
end