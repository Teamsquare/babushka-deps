dep 'crowd.running', :version, :install_prefix, :home_directory, :use_port_80 do
  version.default!('2.5.2')
  install_prefix.default!('/usr/local')
  home_directory.default!('/etc/crowd')
  use_port_80.default!(false)

  requires [
               'jre',
               'crowd'.with(version, install_prefix, home_directory, use_port_80),
               'crowd.startable'.with(version, install_prefix)
           ]

  met? do
    (summary = shell("monit summary")) && summary[/'crowd'.*(Initializing|Running|Not monitored - start pending)/]
  end

  meet do
    shell 'monit start crowd'
  end
end

dep 'crowd.installed', :version, :install_prefix, :home_directory, :use_port_80 do
  version.default!('2.5.2')
  install_prefix.default!('/usr/local')
  home_directory.default!('/etc/crowd')
  use_port_80.default!(false)

  requires [
               'jre',
               'crowd'.with(version, install_prefix, home_directory, use_port_80)
  ]
end

dep 'crowd', :version, :install_prefix, :home_directory, :use_port_80 do
  use_port_80.default!(false)

  setup do
    must_be_root
  end

  met? do
    "#{install_prefix}/crowd/start_crowd.sh".p.exists?
  end

  meet do
    tar_file = "atlassian-crowd-#{version}.tar.gz"
    shell "wget http://www.atlassian.com/software/crowd/downloads/binary/#{tar_file} -P /tmp"
    shell "tar xvf /tmp/#{tar_file} -C #{install_prefix}"
    shell "mv #{install_prefix}/*crowd* #{install_prefix}/crowd"
    shell "rm /tmp/#{tar_file}"
    shell "mkdir -p #{home_directory}"
    shell "echo 'crowd.home=#{home_directory}' >> #{install_prefix}/crowd/crowd-webapp/WEB-INF/classes/crowd-init.properties"

    if use_port_80
      shell "sed -i s/wrapper.app.parameter.2=8095/wrapper.app.parameter.2=80/ #{install_prefix}/crowd/conf/wrapper.conf"
    end
  end
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