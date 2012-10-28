dep 'mmonit.running' do
  requires 'mmonit.src'
end

dep 'mmonit.src', :version do
  version.default!('2.4')
  source "http://mmonit.com/dist/mmonit-#{version}-linux-x64.tar.gz"
  provides 'node', 'node-waf'
end