dep 'pgclient.installed' do
  requires 'postgresql-common.managed', 'libpq-dev'
end

dep 'postgresql-common.managed' do
  provides 'pg_control'
end