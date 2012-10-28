dep 'logio', :install_prefix do
  install_prefix.default!('/usr/local')

  requires 'npm installed'

  met? do
    "#{install_prefix}/log.io".p.exists?
  end

  meet do
    shell 'npm config set unsafe-perm true'
    shell "npm install -g --prefix=#{install_prefix} log.io"
  end
end