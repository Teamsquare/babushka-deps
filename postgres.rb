dep 'pgclient.installed' do
  requires 'pgclient.managed'
end

dep 'pgclient.managed' do
  installs {
    via :apt, 'postgresql-common.managed', 'libpg-dev.managed'
  }
  provides 'pg_control'
end