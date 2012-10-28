dep 'bootstrap minimal', :username, :key, :new_relic_license do
  username.default!('lexim')
  setup do
    unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
  end

  requires [
    'lexim:system'.with(:host_name => shell('hostname -f')),
    'lexim:user setup for provisioning'.with(:username => username, :key => key),
    'lexim:passwordless sudo'.with(username),
    'lexim:monit running',
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

dep 'web node' do
  requires 'lexim:running.nginx'
  requires 'lexim:imagemagick.src'
  # unicorn stuff
end

dep 'resque worker' do
  requires 'lexim:imagemagick.src'
end

dep 'search engine' do
  requires 'lexim:sphinx.src'
end
