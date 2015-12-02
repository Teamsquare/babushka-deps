dep 'pg.ppa' do
  met? {
    "/etc/apt/sources.list.d/pgdg.list".p.exist?
  }
  meet do
    shell 'echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  end
  after {
    shell "apt-get update"
  }
end

dep 'pg.server' do
	requires [
		'python-software-properties.managed',
		'pg.ppa',
		'postgresql-9.2.managed',
		'postgresql-client-9.2.managed', 
		'postgresql-contrib-9.2.managed'
	]
end

dep 'pg.client' do
	requires [
		'python-software-properties.managed',
		'pg.ppa',
		'libpq-dev.managed',
		'postgresql-client-9.2.managed'
	]
end

dep 'libpq-dev.managed' do
	requires 'postgresql-server-dev-9.2.managed'
  provides []
end

dep 'postgresql-9.2.managed' do
	provides 'psql'
end

dep 'postgresql-client-9.2.managed' do
	provides 'pg_config'
end

dep 'postgresql-contrib-9.2.managed'
dep 'postgresql-server-dev-9.2.managed'