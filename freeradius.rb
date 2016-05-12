dep 'freeradius.src', :version do
  version.default!('3.0.11')

  source "ftp://ftp.freeradius.org/pub/freeradius//freeradius-server-#{version}.tar.gz"

  provides 'radiusd'
end
