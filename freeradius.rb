dep 'freeradius.src', :version do
  setup do
    must_be_root
  end

  version.default!('3.0.11')

  requires [
               'snmp.managed',
               'libtalloc-dev.managed'
           ]

  source "ftp://ftp.freeradius.org/pub/freeradius//freeradius-server-#{version}.tar.gz"

  provides 'radiusd'
end
