dep 'pg.ppa' do
	setup do
    must_be_root
  end

  met? {
    "/etc/apt/sources.list.d/pgdg.list".p.exist?
  }

  meet do
    shell 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
		shell 'wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -'
  end

  after {
    shell "apt-get update"
  }
end

dep 'pg.server' do
	requires [
		'postgresql-9.4.managed',
		'postgresql-client-9.4.managed',
		'postgresql-contrib-9.4.managed'
	]
end

dep 'pg.client' do
	requires [
		'libpq-dev.managed',
		'postgresql-client-9.4.managed'
	]
end

dep 'libpq-dev.managed' do
	requires 'postgresql-server-dev-9.4.managed'
  provides []
end

dep 'postgresql-9.4.managed' do
	provides 'psql'
end

dep 'postgresql-client-9.4.managed' do
	provides 'pg_config'
end

dep 'postgresql-contrib-9.4.managed'
dep 'postgresql-server-dev-9.4.managed'
