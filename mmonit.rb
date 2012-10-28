require 'helpers'

dep 'mmonit.running' do
  requires %w(mmonit.src mmonit.startable)
end

dep 'mmonit.src', :version, :prefix do
  requires 'user and group exist'.with(:user => 'mmonit')

  version.default!('2.4')
  prefix.default!('/usr/local')

  met? do
    "#{prefix}/mmonit-#{version}/bin/mmonit".p.exists?
  end

  meet do
    tar_file = "mmonit-#{version}-linux-x64.tar.gz"
    shell "wget http://mmonit.com/dist/#{tar_file} /tmp/#{tar_file}"
    shell "tar xvf /tmp/#{tar_file} -C #{prefix}"
    shell "rm /tmp/#{tar_file}"
  end
end

dep 'mmonit.startable', :version, :prefix do
  version.default!('2.4')
  prefix.default!('/usr/local')

  met? { "/etc/monit/monitrc".p.exists? }
  meet do
    render_erb "monit/mmonit.monitrc.erb", :to => "/etc/monit/mmonit.monitrc", :perms => 700
    shell "monit reload"
  end
end

dep 'mmonit.running', :version, :prefix do
  version.default!('2.4')
  prefix.default!('/usr/local')

  met? do
    (summary = shell("monit summary")) && summary[/'mmonit'.*Running/]
  end

  meet do
    shell 'monit start mmonit'
  end
end