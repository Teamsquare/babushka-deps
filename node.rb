dep 'nodejs.src', :version do
  version.default!('0.10.5')
  source "http://nodejs.org/dist/v#{version}/node-v#{version}.tar.gz"
  provides 'node'
end