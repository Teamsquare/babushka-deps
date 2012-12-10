exclude_on_centos = ['whois']

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

centos_packages_without_binary = [
  'readline-devel',
  'openssl-devel',
  'libxml2-devel',
  'libxslt-devel',
  'zlib-devel',
  'iptables',
  'util-linux-ng',
  'libuuid-devel',
  'libcurl' 
].each { |p|
  dep [p, 'managed'].join('.') do
    provides []
  end
}

dep('core dependencies') {
  if [:centos].include?(Babushka.host.flavour)
    requires (packages.reject { |p| exclude_on_centos.include?(p) } + centos_packages_without_binary).map { |p| "#{p}.managed" }
  else
    requires (packages + packages_without_binary).map { |p| "#{p}.managed" }
  end

}
