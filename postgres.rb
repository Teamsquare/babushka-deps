dep 'pgclient.installed' do
  requires 'libpq-dev.managed', 'postgresql-client.managed'
end

dep 'libpq-dev.managed' do
  provides []
end

dep 'postgresql-client.managed' do
  provides 'pg_config'
end

dep 'postgres' do
  requires 'pgclient.installed'
  requires 'postgres.installed'
end

dep 'postgres.installed' do
  requires 'postgresql.managed'
end

dep 'postgresql.managed' do

end