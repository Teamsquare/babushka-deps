dep 'build essential installed' do
  if [:ubuntu, :debian].include?(Babushka.host.flavour)
    requires %w(build-essential binutils-doc.managed autoconf.managed flex.managed bison.managed)
  else
    requires 'centos build essential installed'
  end
end

dep 'centos build essential installed' do
  met? do
    !(shell('yum -q grouplist "Development Tools"').empty?)
  end

  meet do
    shell('yum groupinstall -y "Development Tools"')
  end
end