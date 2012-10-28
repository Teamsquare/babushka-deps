dep 'unicorn.running' do
  requires %w(unicorn.startable)
end

dep 'unicorn.startable' do
  setup do
    must_be_root
  end

  met? { "/etc/init.d/unicorn".p.exists? && "/etc/monit/conf.d/unicorn_master.monitrc".p.exists? && "/etc/monit/conf.d/unicorn_worker.monitrc".p.exists? }
  meet do
    render_erb 'unicorn/unicorn.init.d.erb', :to => '/etc/init.d/unicorn', :perms => '755', :sudo => true
    render_erb "monit/unicorn_master.monitrc.erb", :to => "/etc/monit/conf.d/unicorn_master.monitrc", :perms => 700
    render_erb "monit/unicorn_worker.monitrc.erb", :to => "/etc/monit/conf.d/unicorn_worker.monitrc", :perms => 700
    shell "monit reload"
  end
end