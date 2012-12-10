packages = [
    'lsof',
    'jwhois',
    'whois',
    'curl',
    'wget',
    'rsync',
    'jnettop',
    'nmap',
    'traceroute',
    'ethtool',
    'tcpdump',
    'elinks',
    'lynx',
    'htop',
    'curl'
].each do |package|
  exclude_on_centos = %w(whois)

  if [:centos].include?(Babushka.host.flavour)
    next if exclude_on_centos.include? package
  end

  dep [package, 'managed'].join('.')
end

packages_without_binary = [
    'iputils-ping',
    'netcat-openbsd',
    'bind9-host',
    'libreadline-dev',
    'libssl-dev',
    'libxml2-dev',
    'libxslt1-dev',
    'zlib1g-dev',
    'iptables',
    'util-linux',
    'libossp-uuid-dev',
    'libcurl3',
    'python-software-properties',
    'libcurl4-openssl-dev'
].each { |p|
  dep [p, 'managed'].join('.') do
    provides []
  end
}

dep('core dependencies') {
  requires (packages + packages_without_binary).map { |p| "#{p}.managed" }
}
