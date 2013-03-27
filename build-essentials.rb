dep 'build essential installed' do
  if [:ubuntu, :debian].include?(Babushka.host.flavour)
    requires %w(binutils-doc.managed autoconf.managed flex.managed bison.managed)
  else
    requires 'centos build essential installed'
  end
end

dep 'centos build essential installed' do
  met? do
    !(shell('yum grouplist "Development Tools"').grep(/Installed Groups/).empty?)
  end

  meet do
    shell('yum groupinstall -y "Development Tools"')
  end
end