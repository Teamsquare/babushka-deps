dep 'bamboo.installed', :version, :install_prefix, :home_directory, :bamboo_user do
  version.default!('4.3.3')
  install_prefix.default!('/usr/local/atlassian')
  home_directory.default!('/etc/bamboo')
  bamboo_user.default!('atlassian')

  requires [
               'jdk'.with(6),
               'user and group exist'.with('atlassian', 'atlassian'),
               'bamboo'.with(version, install_prefix, home_directory),
               'bamboo.home_directory_set'.with(install_prefix, home_directory),
               'atlassian.permissions'.with(install_prefix, home_directory, bamboo_user, 'bamboo')

           ]
end

dep 'bamboo', :version, :install_prefix, :home_directory do
  setup do
    must_be_root
  end

  met? do
    "#{install_prefix}/bamboo/bamboo.sh".p.exists?
  end

  meet do
    shell "mkdir -p #{install_prefix}"
    tar_file = "atlassian-bamboo-#{version}.tar.gz"
    shell "wget http://www.atlassian.com/software/bamboo/downloads/binary/#{tar_file} -P /tmp"
    shell "tar xvf /tmp/#{tar_file} -C #{install_prefix}"
    shell "mv #{install_prefix}/*bamboo* #{install_prefix}/bamboo"
    shell "rm /tmp/#{tar_file}"
  end
end

dep 'bamboo.home_directory_set', :install_prefix, :home_directory do
  setup do
    must_be_root
  end

  met? do
    "#{install_prefix}/bamboo/webapp/WEB-INF/classes/bamboo-init.properties".p.grep(/#{home_directory}/)
  end

  meet do
    shell "mkdir -p #{home_directory}"
    shell "echo 'bamboo.home=#{home_directory}' >> #{install_prefix}/bamboo/webapp/WEB-INF/classes/bamboo-init.properties"
  end
end

