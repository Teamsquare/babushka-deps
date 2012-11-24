dep 'jira.installed', :version, :install_prefix, :home_directory, :jira_user do
  version.default!('5.2')
  install_prefix.default!('/usr/local')
  home_directory.default!('/etc/jira')
  jira_user.default!('jira')

  requires [
               'jre'.with(6),
               'jira.user'.with(jira_user),
               'jira'.with(version, install_prefix),
               'jira.home_directory_set'.with(install_prefix, home_directory),
               'jira.permissions'.with(install_prefix, home_directory, jira_user)
           ]
end

dep 'jira.user', :username do
  setup do
    must_be_root
  end

  met? {
    '/etc/passwd'.p.grep(/^#{username}\:/) and
        '/etc/group'.p.grep(/^#{username}\:/)
  }

  meet {
    shell "groupadd #{username}"
    shell "useradd --create-home --comment 'Account for running JIRA' -g #{username} -s /bin/bash #{username}"
  }
end

dep 'jira', :version, :install_prefix do
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

dep 'jira.permissions', :install_prefix, :home_directory, :username do
  met? do
    output = shell?("stat #{install_prefix}/jira/logs | grep Uid | grep #{username}")

    !output.nil?
  end

  meet do
    shell "chown -R root:root #{install_prefix}/jira/"
    shell "chown -R #{username}:#{username} #{install_prefix}/jira/logs"
    shell "chown -R #{username}:#{username} #{install_prefix}/jira/temp"
    shell "chown -R #{username}:#{username} #{install_prefix}/jira/work"
    shell "chown -R #{username}:#{username} #{home_directory}"
  end
end