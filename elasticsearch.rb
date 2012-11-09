dep 'elasticsearch.running', :version, :install_prefix do
  version.default!('0.19.11')
  install_prefix.default!('/usr/local')

  requires [
    'jre',
    'elasticsearch'.with(version, install_prefix),
    'elasticsearch.startable'.with(version, install_prefix),
  ]

  met? do
    (summary = shell("monit summary")) && summary[/'elasticsearch'.*(Initializing|Running|Not monitored - start pending)/]
  end

  meet do
    shell 'monit start elasticsearch'
  end
end

dep 'elasticsearch', :version, :install_prefix do
  setup do
    must_be_root
  end

  met? do
    "#{install_prefix}/elasticsearch-#{version}/bin/elasticsearch".p.exists?
  end

  meet do
    tar_file = "elasticsearch-#{version}.tar.gz"
    shell "wget https://github.com/downloads/elasticsearch/elasticsearch/#{tar_file} -P /tmp"
    shell "tar xvf /tmp/#{tar_file} -C #{install_prefix}"
    shell "mv #{install_prefix}/*elasticsearch* #{install_prefix}/elasticsearch"
    shell "rm /tmp/#{tar_file}"

    shell "curl -L http://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/master -P /tmp | tar -xz"
    shell "mv *servicewrapper*/service #{install_prefix}/elasticsearch/bin/"
    shell "rm -rf /tmp/*servicewrapper*"
  end
end


dep 'elasticsearch.startable', :version, :install_prefix do
  setup do
    must_be_root
  end

  requires 'monit running'

  met? { "/etc/monit/conf.d/elasticsearch.monitrc".p.exists? }
  meet do
    shell "#{install_prefix}/elasticsearch/bin/service/elasticsearch install"
    render_erb "monit/elasticsearch.monitrc.erb", :to => "/etc/monit/conf.d/elasticsearch.monitrc", :perms => 700
    shell "monit reload"
  end
end