dep 'bootstrap minimal', :username, :key, :new_relic_license do
  username.default!('lexim')
  setup do
    unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
  end

  requires [
    'lexim:system'.with(:host_name => shell('hostname -f')),
    'lexim:user setup for provisioning'.with(:username => username, :key => key),
    'lexim:passwordless sudo'.with(username),
    'lexim:rpm monitoring'.with(new_relic_license),
    'lexim:core dependencies',
    'lexim:core software'
  ]
end

dep 'bootstrap ruby', :username, :key, :new_relic_license do
  username.default!('lexim')

  setup do
    unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
  end

  requires [
    'lexim:bootstrap minimal'.with(username, key, new_relic_license),
    'lexim:build essential installed',
    'lexim:nodejs installed',
    'lexim:ruby.src',
    'lexim:bundler.gem'
  ]
end

dep 'bootstrap jruby', :username, :key, :new_relic_license, :install_prefix do
  username.default!('lexim')
  install_prefix.default!('/usr/local')

  setup do
    unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
  end

  requires [
               'lexim:bootstrap minimal'.with(username, key, new_relic_license),
               'lexim:build essential installed',
               'lexim:nodejs installed',
               'lexim:jdk.with(6)',
               'lexim:jruby'.with('1.7.1', install_prefix),
               'lexim:bundler.gem'
           ]
end

dep 'after bootstrap', :username do
  username.default!('lexim')

  setup do
    unmeetable! "This dep must be run as the generated user from 'bootstrap lexim'" unless shell('whoami') == username
  end

  requires [
    'lexim:secured ssh logins',
    'lexim:user can write to usr local'
  ]
end

dep 'jboss node' do
  requires 'lexim:bootstrap minimal'
  requires 'lexim:bootstrap jruby'
end

dep 'web node', :logio_server do
  requires 'lexim:monit running'
  requires 'lexim:running.nginx'
  requires 'lexim:imagemagick.managed'
  requires 'lexim:pgclient.installed'
  requires 'unicorn.startable'
  requires 'lexim:logio.harvester'.with(:logio_server => logio_server, :node_type => 'web')
end

dep 'drone', :logio_server do
  requires 'lexim:monit running'
  requires 'lexim:imagemagick.managed'
  requires 'lexim:redis.running'
  requires 'lexim:memcached.running'
  requires 'lexim:pgclient.installed'
  requires 'lexim:sphinx.src'
  requires 'lexim:logio.harvester'.with(:logio_server => logio_server, :node_type => 'drone')
end