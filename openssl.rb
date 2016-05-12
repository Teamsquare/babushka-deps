dep 'openssl.src', :version do
  setup do
    must_be_root
  end

  version.default!('1.0.2h')

  source "https://www.openssl.org/source/openssl-#{version}.tar.gz"

  provides 'openssl'
end
