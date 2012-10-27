dep('nodejs installed') {
  requires 'nodejs.src'
}

dep 'nodejs.src', :version do
  version.default!('0.4.12')
  source "http://nodejs.org/dist/node-v#{version}.tar.gz"
  provides 'node', 'node-waf'
end