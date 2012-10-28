dep 'mmonit.running', :version, :install_prefix do
  version.default!('2.4')
  install_prefix.default!('/usr/local')

  requires %w(mmonit mmonit.startable)

  setup do
    must_be_root
  end

  met? do
    (summary = shell("monit summary")) && summary[/'mmonit'.*Running/]
  end

  meet do
    shell 'monit start mmonit'
  end
end

dep 'mmonit', :version, :install_prefix do
  setup do
    must_be_root
  end

  requires 'user and group exist'.with(:user => 'mmonit')

  version.default!('2.4')
  install_prefix.default!('/usr/local')

  met? do
    "#{install_prefix}/mmonit-#{version}/bin/mmonit".p.exists?
  end

  meet do
    tar_file = "mmonit-#{version}-linux-x64.tar.gz"
    shell "wget http://mmonit.com/dist/#{tar_file}"
    shell "tar xvf #{tar_file} -C #{install_prefix}"
    shell "rm #{tar_file}"
  end
end

dep 'mmonit.startable', :version, :install_prefix do
  setup do
    must_be_root
  end

  version.default!('2.4')
  install_prefix.default!('/usr/local')

  met? { "/etc/monit/monitrc".p.exists? }
  meet do
    render_erb "monit/mmonit.monitrc.erb", :to => "/etc/monit/mmonit.monitrc", :perms => 700
    shell "monit reload"
  end
end