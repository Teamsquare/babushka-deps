dep 'pgclient.installed' do
  requires 'postgresql-common.managed'
end

dep 'postgresql-common.managed' do
  provides 'pg_control'
end