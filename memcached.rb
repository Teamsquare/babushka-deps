dep 'memcached.running' do
  requires %w(memcached.src memcached.startable)

  setup do
    must_be_root
  end

  met? do
    (summary = shell("monit summary")) && summary[/'memcached'/]
  end

  meet do
    shell '/etc/init.d/memcached stop && monit start memcached'
  end
end

dep 'memcached.src' do
  requires 'libevent-devel.managed'
  source 'http://memcached.org/latest'
end


dep 'memcached.startable' do
  setup do
    must_be_root
  end

  met? { "/etc/monit/conf.d/memcached.monitrc".p.exists? }
  meet do
    render_erb "monit/memcached.monitrc.erb", :to => "/etc/monit/conf.d/memcached.monitrc", :perms => 700
    shell "monit reload"
  end
end