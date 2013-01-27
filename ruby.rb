dep 'ruby trunk.src' do
  requires 'bison.managed', 'readline headers.managed'
  source 'git://github.com/ruby/ruby.git'
  provides 'ruby == 1.9.3.dev', 'gem', 'irb'
  configure_args '--disable-install-doc', '--with-readline-dir=/usr'
end

dep 'ruby.src', :version, :patchlevel do
  def version_group
    version.to_s.scan(/^\d\.\d/).first
  end

  version.default!('1.9.3')
  patchlevel.default!('p374')
  requires 'readline headers.managed', 'yaml headers.managed'
  source "ftp://ftp.ruby-lang.org/pub/ruby/#{version_group}/ruby-#{version}-#{patchlevel}.tar.gz"
  provides "ruby == #{version}#{patchlevel}", 'gem', 'irb'
  configure_args '--disable-install-doc',
                 "--with-readline-dir=#{Babushka.host.pkg_helper.prefix}",
                 "--with-libyaml-dir=#{Babushka.host.pkg_helper.prefix}"
  postinstall {
    # TODO: hack for ruby bug where bin/* aren't installed when the build path
    # contains a dot-dir.
    shell "cp bin/* #{prefix / 'bin'}", :sudo => Babushka::SrcHelper.should_sudo?
  }
end

dep 'jruby', :version, :install_prefix do
  version.default!('1.7.1')

  requires 'readline headers.managed',
           'yaml headers.managed'

  setup do
    must_be_root
  end

  met? do
    "#{install_prefix}/jruby/bin/jruby.sh".p.exists?
  end

  meet do
    tar_file = "jruby-bin-#{version}.tar.gz"
    shell "wget http://jruby.org.s3.amazonaws.com/downloads/#{version}/#{tar_file} -P /tmp"
    shell "tar xvf /tmp/#{tar_file} -C #{install_prefix}"
    shell "mv #{install_prefix}/*jruby* #{install_prefix}/jruby"
    shell "rm /tmp/#{tar_file}"
  end
end
