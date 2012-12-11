dep 'bamboo.running', :version, :install_prefix, :home_directory do
  version.default!('4.3.1')
  install_prefix.default!('/usr/local')
  home_directory.default!('/etc/bamboo')

  requires [
               'jdk'.with(6),
               'bamboo'.with(version, install_prefix, home_directory),
               'bamboo.startable'.with(version, install_prefix)
           ]

  met? do
    (summary = shell("monit summary")) && summary[/'bamboo'.*(Initializing|Running|Not monitored - start pending)/]
  end

  meet do
    shell 'monit start bamboo'
  end
end

dep 'bamboo.installed', :version, :install_prefix, :home_directory do
  version.default!('4.3.1')
  install_prefix.default!('/usr/local')
  home_directory.default!('/etc/bamboo')

  requires [
               'jdk'.with(6),
               'bamboo'.with(version, install_prefix, home_directory),
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
    tar_file = "atlassian-bamboo-#{version}.tar.gz"
    shell "wget http://www.atlassian.com/software/bamboo/downloads/binary/#{tar_file} -P /tmp"
    shell "tar xvf /tmp/#{tar_file} -C #{install_prefix}"
    shell "mv #{install_prefix}/*bamboo* #{install_prefix}/bamboo"
    shell "rm /tmp/#{tar_file}"
    shell "mkdir -p #{home_directory}"
    shell "echo 'bamboo.home=#{home_directory}' >> #{install_prefix}/bamboo/webapp/WEB-INF/classes/bamboo-init.properties"
    shell "sed -i s/wrapper.app.parameter.2=8085/wrapper.app.parameter.2=80/ #{install_prefix}/bamboo/conf/wrapper.conf"
  end
end

dep 'bamboo.startable', :version, :install_prefix do
  setup do
    must_be_root
  end

  requires 'monit running'

  met? { "/etc/monit/conf.d/bamboo.monitrc".p.exists? }

  meet do
    render_erb "monit/bamboo.monitrc.erb", :to => "/etc/monit/conf.d/bamboo.monitrc", :perms => 700
    shell "monit reload"
  end
end