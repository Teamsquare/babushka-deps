dep 'passwordless ssh logins', :username, :key do
  username.default(shell('whoami'))
  def ssh_dir
    "~#{username}" / '.ssh'
  end
  def group
    shell "id -gn #{username}"
  end
  def sudo?
    @sudo ||= username != shell('whoami')
  end
  met? {
    shell? "fgrep '#{key}' '#{ssh_dir / 'authorized_keys'}'", :sudo => sudo?
  }
  meet {
    shell "mkdir -p -m 700 '#{ssh_dir}'", :sudo => sudo?
    shell "cat >> #{ssh_dir / 'authorized_keys'}", :input => key, :sudo => sudo?
    sudo "chown -R #{username}:#{group} '#{ssh_dir}'" unless ssh_dir.owner == username
    shell "chmod 600 #{(ssh_dir / 'authorized_keys')}", :sudo => sudo?
  }
end

dep 'public key' do
  met? { '~/.ssh/id_dsa.pub'.p.grep(/^ssh-dss/) }
  meet { log shell("ssh-keygen -t dsa -f ~/.ssh/id_dsa -N ''") }
end

dep 'bad certificates removed', :for => [:debian, :ubuntu] do
  def cert_names
    %w[
      DigiNotar_Root_CA
    ]
  end
  def existing_certs
    cert_names.map {|name|
      "/etc/ssl/certs/#{name}.pem".p
    }.select {|cert|
      cert.exists?
    }
  end
  met? { existing_certs.empty? }
  meet { existing_certs.each(&:rm) }
end

dep 'install public key', :key_contents do
  met? do
    username = shell('whoami')
    "/home/#{username}/.ssh/authorized_keys".p.grep(key_contents)
  end

  meet do
    username = shell('whoami')
    shell "echo #{key_contents} >> /home/#{username}/.ssh/authorized_keys"
  end
end

dep 'install private key', :key_name, :key_contents do
  met? do
    username = shell('whoami')
    "/home/#{username}/.ssh/#{key_name}".p.exists?
  end

  meet do
    username = shell('whoami')
    shell "echo #{key_contents} > /home/#{username}/.ssh/#{key_name}"
  end
end