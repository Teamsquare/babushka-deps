dep 'resque.running' do
  requires 'resque.startable'

  setup do
    must_be_root
  end

  met? do
    (summary = shell("monit summary")) && summary[/'resque'.*(Initializing|Running|Not monitored - start pending)/]
  end

  meet do
    shell 'monit start resque'
    shell 'monit start resque_scheduler'
  end
end

dep 'resque.startable' do
  requires 'einhorn.gem'
  
  met? { "/etc/init/resque.conf".p.exists? && "/etc/init/resque_scheduler.conf".p.exists? && "/etc/monit/conf.d/resque.monitrc".p.exists? && "/etc/monit/conf.d/resque_scheduler.monitrc".p.exists? }
  meet do
    render_erb 'resque/resque.init.conf.erb', :to => '/etc/init/resque.conf', :perms => '755', :sudo => true
    render_erb 'resque/resque_scheduler.init.conf.erb', :to => '/etc/init/resque_scheduler.conf', :perms => '755', :sudo => true
    render_erb "monit/resque.monitrc.erb", :to => "/etc/monit/conf.d/resque.monitrc", :perms => 700
    render_erb "monit/resque_scheduler.monitrc.erb", :to => "/etc/monit/conf.d/resque_scheduler.monitrc", :perms => 700
    shell "monit reload"
  end
end