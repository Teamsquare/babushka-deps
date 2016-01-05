dep 'nodejs.src', :version do
  version.default!('4.2.4')
  source "https://nodejs.org/dist/v#{version}/node-v#{version}.tar.gz"
  provides 'node'
end
