dep 'pgclient.installed' do
  requires 'libpq-dev.managed', 'postgresql-client.managed'
end

dep 'libpq-dev.managed' do
  provides []
end

dep 'postgresql-client.managed' do
  provides 'pg_control'
end