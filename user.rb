dep 'provision admin', :username, :key do
  setup do
    must_be_root
  end

  requires [
    'user setup for provisioning'.with(:username => username, :key => key),
    'passwordless sudo'.with(username)
  ]
end

dep 'user setup for provisioning', :username, :key, :home_dir_base do
  home_dir_base.default!('/home')
  requires [
               'user exists'.with(:username => username, :home_dir_base => home_dir_base),
               'passwordless ssh logins'.with(username, key)
            ]
end

dep 'user exists', :username, :home_dir_base, :admin do
  admin.default!(true)
  home_dir_base.default(username['.'] ? '/srv/http' : '/home')

  on :osx do
    met? { !shell("dscl . -list /Users").split("\n").grep(username).empty? }
    meet {
      homedir = home_dir_base / username
      {
          'Password' => '*',
          'UniqueID' => (501...1024).detect {|i| (Etc.getpwuid i rescue nil).nil? },
          'PrimaryGroupID' => 'admin',
          'RealName' => username,
          'NFSHomeDirectory' => homedir,
          'UserShell' => '/bin/bash'
      }.each_pair {|k,v|
        # /Users/... here is a dscl path, not a filesystem path.
        sudo "dscl . -create #{'/Users' / username} #{k} '#{v}'"
      }
      sudo "mkdir -p '#{homedir}'"
      sudo "chown #{username}:admin '#{homedir}'"
      sudo "chmod 701 '#{homedir}'"
    }
  end
  on :linux do
    met? { '/etc/passwd'.p.grep(/^#{username}:/) }
    meet {
      sudo "mkdir -p #{home_dir_base}" and
          sudo "useradd -m -s /bin/bash -b #{home_dir_base} -G #{admin ? 'admin' : 'users'} #{username}" and
          sudo "chmod 701 #{home_dir_base / username}"
    }
  end
end

dep 'user can write to usr local' do
  def user
    shell 'whoami'
  end

  met? {
    shell? "touch /usr/local/lib/touch-this"
  }

  meet {
    shell "chown -R #{user}:#{user} /usr/local/", :sudo => true
  }
end

dep 'user and group exist', :user, :group do
  group.default!(user)

  met? do
    '/etc/passwd'.p.grep(/^#{user}\:/) and
    '/etc/group'.p.grep(/^#{group}\:/)
  end

  meet do
    sudo "groupadd #{group}"
    shell "useradd --create-home -g #{group} -s /bin/bash #{user}"
  end

end