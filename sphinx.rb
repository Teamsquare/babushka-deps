dep 'sphinx.src', :version do
  requires ['libpq-dev.managed']
  
  version.default!('2.0.7')
  source "http://sphinxsearch.com/files/sphinx-#{version}-release.tar.gz"

  provides 'search', 'searchd', 'indexer'

  configure_args L{
    [
        ("--with-pgsql=#{shell 'pg_config --pkgincludedir'}" if confirm("Build with postgres support?")),
        ("--without-mysql" unless confirm("Build with mysql support?"))
    ].compact.join(" ")
  }
end