dep 'crowd', :version, :install_prefix, :home_directory do
  version.default!('2.8.3')
  install_prefix.default!('/usr/local/atlassian')
  home_directory.default!('/etc/crowd')

  requires [
               'jdk',
               'atlassian.user_exists',
               'atlassian.product.installed'.with('crowd', version, install_prefix, "atlassian-crowd-#{version}.tar.gz"),
               'atlassian.product.home_directory_set'.with('crowd', install_prefix, home_directory),
               'atlassian.permissions'.with(install_prefix, home_directory, 'crowd', 'atlassian')
           ]
end

dep 'crowd.startable', :version, :install_prefix do
  setup do
    must_be_root
  end

  requires 'monit running'

  met? { "/etc/monit/conf.d/crowd.monitrc".p.exists? }

  meet do
    render_erb "monit/crowd.monitrc.erb", :to => "/etc/monit/conf.d/crowd.monitrc", :perms => 700
    shell "monit reload"
  end
end

dep 'crowd.running', :version, :install_prefix, :home_directory do
  version.default!('2.8.3')
  install_prefix.default!('/usr/local/atlassian')
  home_directory.default!('/etc/crowd')

  requires [
               'jdk'.with(6),
               'crowd'.with(version, install_prefix, home_directory),
               'crowd.startable'.with(version, install_prefix)
           ]

  met? do
    (summary = shell("monit summary")) && summary[/'crowd'.*(Initializing|Running|Not monitored - start pending)/]
  end

  meet do
    shell 'monit start crowd'
  end
end
