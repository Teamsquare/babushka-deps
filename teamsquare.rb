dep 'bootstrap minimal', :username, :key do
  username.default!('ubuntu')
  setup do
    unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
  end

  requires [
    'teamsquare:system'.with(:host_name => shell('hostname -f')),
    'teamsquare:user setup for provisioning'.with(:username => username, :key => key),
    'teamsquare:passwordless sudo'.with(username),
    'teamsquare:core dependencies',
    'teamsquare:core software'
  ]
end

dep 'bootstrap ruby', :username, :key do
  username.default!('ubuntu')

  setup do
    unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
  end

  requires [
    'teamsquare:bootstrap minimal'.with(username, key),
    'teamsquare:build essential installed',
    'teamsquare:nodejs installed',
    'teamsquare:ruby.src',
    'teamsquare:bundler.gem'
  ]
end

dep 'bootstrap jruby', :username, :key, :install_prefix do
  username.default!('ubuntu')
  install_prefix.default!('/usr/local')

  setup do
    unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
  end

  requires [
               'teamsquare:bootstrap minimal'.with(username, key),
               'teamsquare:build essential installed',
               'teamsquare:nodejs installed',
               'teamsquare:jdk'.with(6),
               'teamsquare:jruby'.with('1.7.1', install_prefix),
               'teamsquare:bundler.gem'
           ]
end

dep 'after bootstrap', :username do
  username.default!('ubuntu')

  setup do
    unmeetable! "This dep must be run as the generated user from 'bootstrap minimal' or 'bootstrap ruby" unless shell('whoami') == username
  end

  requires [
    'teamsquare:secured ssh logins',
    'teamsquare:user can write to usr local'
  ]
end

dep 'jboss node' do
  requires 'teamsquare:bootstrap minimal'
  requires 'teamsquare:bootstrap jruby'
end

dep 'web node', :logio_server do
  requires 'teamsquare:monit running'
  requires 'teamsquare:running.nginx'
  requires 'teamsquare:imagemagick.managed'
  requires 'teamsquare:pgclient.installed'
  requires 'unicorn.startable'
  requires 'teamsquare:logio.harvester'.with(:logio_server => logio_server, :node_type => 'web')
end

dep 'drone', :logio_server do
  requires 'teamsquare:monit running'
  requires 'teamsquare:imagemagick.managed'
  requires 'teamsquare:redis.running'
  requires 'teamsquare:memcached.running'
  requires 'teamsquare:pgclient.installed'
  requires 'teamsquare:sphinx.src'
  requires 'teamsquare:logio.harvester'.with(:logio_server => logio_server, :node_type => 'drone')
end