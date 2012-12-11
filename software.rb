dep 'core software' do
  setup do
    if [:centos].include?(Babushka.host.flavour)
      installed = false

      shell("rpm -q epel-release-6-7.noarch") do |cmd|
        installed = cmd.stdout.grep(/is not installed/).empty?
      end

      unless installed
        sudo("rpm -Uvh http://download3.fedora.redhat.com/pub/epel/6/x86_64/epel-release-6-7.noarch.rpm")
      end
    end
  end

  requires {
    on :linux, 'vim.managed', 'curl.managed', 'htop.managed', 'jnettop.managed', 'screen.managed', 'nmap.managed', 'tree.managed'
  }
end

dep 'wget.managed' do
  installs {
    via :apt, 'wget'
    via :yum, 'wget'
  }
  provides "wget"
end

dep 'nmap.managed'
dep 'screen.managed'
dep 'jnettop.managed' do
  installs { via :apt, 'jnettop' }
end
dep 'htop.managed'
dep 'tree.managed'
dep 'wget.managed'
dep 'zlib headers.managed' do
  installs { via :apt, 'zlib1g-dev' }
  provides []
end

dep 'sshd.managed' do
  installs {
    via :apt, 'openssh-server'
  }
end
