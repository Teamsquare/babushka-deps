dep 'bootstrap lexim', :username, :key do
  setup do
    unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
  end

  requires [
    'lexim:system'.with(:hostname_str => shell('hostname -f')),
    'lexim:user setup for provisioning'.with(:username => username, :key => key),
    'lexim:core dependencies',
    'lexim:build essential installed',
    'lexim:nodejs installed',
    'lexim:core software',
    'lexim:passwordless sudo',
    'lexim:ruby.src'
  ]
end

dep('after bootstrap', :domain) do
  setup do
    unmeetable! "This dep cannot be run as root." if shell('whoami') == 'root'
  end

  requires [
    'lexim:secured ssh logins',
    'lexim:user can write to usr local',
    'bundler.gem'
  ]

end

dep 'web node' do
  requires 'running.nginx'
end
