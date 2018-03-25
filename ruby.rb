dep 'ruby.src', :version, :patchlevel do
  def version_group
    version.to_s.scan(/^\d\.\d/).first
  end

  version.default!('2.4.3')
  patchlevel.default!('p205')
  requires 'readline headers.managed', 'yaml headers.managed'
  source "https://cache.ruby-lang.org/pub/ruby/#{version_group}/ruby-#{version}.tar.gz"
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
