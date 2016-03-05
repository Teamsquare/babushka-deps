dep 'bamboo.rails', :version, :install_prefix, :home_directory do
  requires [
    'bamboo.installed',
    'build essential installed',
    'nodejs.src',
    'rvm',
    'libgmp3-dev',
    'pg.server'
  ]
end
