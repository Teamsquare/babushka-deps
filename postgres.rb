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
