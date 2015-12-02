dep 'bootstrap minimal', :username, :key do
  username.default!('ubuntu')
  setup do
    must_be_root
  end

  requires [
    'system'.with(:host_name => shell('hostname -f')),
    'user setup for provisioning'.with(:username => username, :key => key),
    'passwordless sudo'.with(username),
    'core dependencies',
    'core software'
  ]
end

dep 'bootstrap ruby', :username, :key do
  username.default!('ubuntu')

  setup do
    must_be_root
  end

  requires [
    'bootstrap minimal'.with(username, key),
    'build essential installed',
    'nodejs.src',
    'ruby.src',
    'bundler.gem'
  ]
end

dep 'after bootstrap', :username do
  username.default!('ubuntu')

  setup do
    unmeetable! "This dep must be run as the generated user from 'bootstrap minimal' or 'bootstrap ruby" unless shell('whoami') == username
  end

  requires [
    'secured ssh logins',
    'user can write to usr local'
  ]
end