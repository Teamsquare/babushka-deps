dep 'redis.running' do
  requires %w(redis-server.managed redis.startable)

  setup do
    must_be_root
  end

  met? do
    (summary = shell("monit summary")) && summary[/'redis'/]
  end

  meet do
    shell '/etc/init.d/redis-server stop && monit start redis'
  end
end

dep 'redis-server.managed'

dep 'redis.startable', :version do
  setup do
    must_be_root
  end

  version.default!('2.6.2')

  met? { "/etc/monit/redis.monitrc".p.exists? }
  meet do
    render_erb "monit/redis.monitrc.erb", :to => "/etc/monit/conf.d/redis.monitrc", :perms => 700
    shell "monit reload"
  end
end