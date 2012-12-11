dep 'ubuntu build essential installed', :for => [:ubuntu, :debian] do
  requires %w(build-essential binutils-doc.managed autoconf.managed flex.managed bison.managed)
end

dep 'centos build essential installed', :for => :centos do
  met? do
    !(shell('yum -q grouplist "Development Tools"').empty?)
  end

  meet do
    shell('yum groupinstall "Development Tools"')
  end
end