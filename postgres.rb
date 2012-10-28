dep 'pgclient.installed' do
  requires 'libpg-dev.managed'
end

dep 'libpg-dev.managed' do
  provides 'pg_control'
end