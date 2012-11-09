dep 'logstash.indexer.running', :version, :install_prefix, :conf_prefix do
  version.default!('1.1.4')
  install_prefix.default!('/usr/local')
  config_prefix.default!('/etc/logstash')

  requires 'logstash.running'.with(version, install_prefix, conf_prefix, 'indexer')
end

dep 'logstash.shipper.running', :version, :install_prefix, :conf_prefix do
  version.default!('1.1.4')
  install_prefix.default!('/usr/local')
  config_prefix.default!('/etc/logstash')

  requires 'logstash.running'.with(version, install_prefix, conf_prefix, 'shipper')
end

dep 'logstash.running', :version, :install_prefix, :conf_prefix, :agent_role do
  version.default!('1.1.4')
  install_prefix.default!('/usr/local')
  config_prefix.default!('/etc/logstash')
  agent_role.default!('indexer')

  requires [
               'jre',
               'logstash'.with(version, install_prefix),
               'logstash'.with(version, install_prefix, agent_role),
               'logstash.startable'.with(version, install_prefix, agent_role),
           ]

  met? do
    (summary = shell("monit summary")) && summary[/'logstash-#{agent_role}'.*(Initializing|Running|Not monitored - start pending)/]
  end

  meet do
    shell "monit start logstash-#{agent_role}"
  end
end

dep 'logstash', :version, :install_prefix do
  setup do
    must_be_root
  end

  met? do
    jar_file = "logstash-#{version}-monolithic.jar"
    "#{install_prefix}/logstash/#{jar_file}".p.exists?
  end

  meet do
    jar_file = "logstash-#{version}-monolithic.jar"

    shell "mkdir -p #{install_prefix}/logstash"
    shell "wget https://logstash.objects.dreamhost.com/release/#{jar_file} -P #{install_prefix}/logstash"
  end
end

dep 'logstash', :version, :conf_prefix, :agent_role do
  agent_role.default!('indexer')

  setup do
    must_be_root
  end

  met? do
    conf_prefix.p.exists? && "#{conf_prefix}/logstash.#{agent_role}.conf".p.exists?
  end

  meet do
    unless conf_prefix.p.exists?
      shell "mkdir -p #{conf_prefix}"
    end

    unless "#{conf_prefix}/logstash.#{agent_role}.conf".p.exists?
      render_erb "monit/logstash-#{agent_role}.monitrc.erb", :to => "/etc/monit/conf.d/logstash-#{agent_role}.monitrc", :perms => 700
      render_erb "logstash/logstash-#{agent_role}.init.d.erb", :to => "/etc/init.d/logstash-#{agent_role}", :perms => 700
    end
  end
end

dep 'logstash.startable', :version, :install_prefix, :agent_role do
  agent_role.default!('indexer')

  setup do
    must_be_root
  end

  requires 'monit running'

  met? { "/etc/monit/conf.d/logstash-#{agent_role}.monitrc".p.exists? }
  meet do
    render_erb "monit/logstash-#{agent_role}.monitrc.erb", :to => "/etc/monit/conf.d/logstash-#{agent_role}.monitrc", :perms => 700
    shell "monit reload"
  end
end