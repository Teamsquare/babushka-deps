dep 'bamboo.installed', :version, :install_prefix, :home_directory do
  version.default!('5.10.1.1')
  install_prefix.default!('/usr/local/atlassian')
  home_directory.default!('/etc/bamboo')

  requires [
               'jdk',
               'atlassian.user_exists',
               'atlassian.product.installed'.with('bamboo', version, install_prefix, "atlassian-bamboo-#{version}.tar.gz"),
               'bamboo.home_directory_set'.with(install_prefix, home_directory),
               'atlassian.permissions'.with(install_prefix, home_directory, 'bamboo', 'atlassian')
           ]
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
    shell "echo 'bamboo.home=#{home_directory}' > #{install_prefix}/bamboo/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties"
  end
end
