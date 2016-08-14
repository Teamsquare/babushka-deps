dep 'confluence.installed', :version, :install_prefix, :home_directory do
  version.default!('5.10.3')
  install_prefix.default!('/usr/local/atlassian')
  home_directory.default!('/etc/confluence')

  requires [
               'jdk',
               'atlassian.user_exists',
               'atlassian.product.installed'.with('confluence', version, install_prefix, "atlassian-confluence-#{version}.tar.gz"),
               'confluence.home_directory_set'.with(install_prefix, home_directory),
               'atlassian.permissions'.with(install_prefix, home_directory, 'confluence', 'atlassian')
           ]
end

dep 'confluence.home_directory_set', :install_prefix, :home_directory do
  setup do
    must_be_root
  end

  met? do
    "#{install_prefix}/confluence/confluence/WEB-INF/classes/confluence-init.properties".p.grep(/#{home_directory}/)
  end

  meet do
    shell "mkdir -p #{home_directory}"
    shell "echo 'confluence.home=#{home_directory}' >> #{install_prefix}/confluence/confluence/WEB-INF/classes/confluence-init.properties"
  end
end
