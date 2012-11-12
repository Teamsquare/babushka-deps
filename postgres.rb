dep 'pgclient.installed' do
  requires 'libpq-dev.managed', 'postgresql-client.managed'
end

dep 'libpq-dev.managed' do
  provides []
end

dep 'postgresql-client.managed' do
  provides 'pg_config'
end

dep 'postgres.installed' do
  requires 'postgres.managed'
end

dep 'postgres.managed' do

end