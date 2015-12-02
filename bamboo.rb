dep 'bamboo.installed', :version, :install_prefix, :home_directory do
  version.default!('4.4.5')
  install_prefix.default!('/usr/local/atlassian')
  home_directory.default!('/etc/bamboo')

  requires [
               'jdk'.with(7),
               'atlassian.user_exists',
               'bamboo'.with(version, install_prefix, home_directory),
               'bamboo.home_directory_set'.with(install_prefix, home_directory),
               'atlassian.permissions'.with(install_prefix, home_directory, 'bamboo', 'atlassian')

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

