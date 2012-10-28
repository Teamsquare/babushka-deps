dep 'pgclient.installed' do
  requires 'libpq-dev.managed'
end

dep 'libpq-dev.managed' do
  provides 'pg_control'
end