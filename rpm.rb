dep 'rpm monitoring', :new_relic_license do
  setup do
    must_be_root
  end

  requires [
    'new relic apt-get source registered',
    'new relic public key installed',
    'newrelic-sysmond.managed',
    'new relic configured'.with(new_relic_license),
    'new relic started'
  ]
end

dep 'new relic apt-get source registered' do
  setup do
    must_be_root
  end

  met? do
    "/etc/apt/sources.list.d/newrelic.list".p.exists?
  end

  meet do
    shell('wget -O /etc/apt/sources.list.d/newrelic.list http://download.newrelic.com/debian/newrelic.list')
  end
end

dep 'new relic public key installed' do
  setup do
    must_be_root
  end

  met? do
    (keys = shell('apt-key list')) && keys[/548C16BF/]
  end

  meet do
    shell('apt-key adv --keyserver hkp://subkeys.pgp.net --recv-keys 548C16BF')
  end

  after do
    shell 'apt-get update'
  end
end

dep 'new relic configured', :new_relic_license do
  setup do
    must_be_root
  end

  shell "nrsysmond-config --set license_key=#{new_relic_license}"
end

dep 'new relic started' do
  setup do
    must_be_root
  end

  shell '/etc/init.d/newrelic-sysmond start'
end

dep 'newrelic-sysmond.managed' do
  installs {
    via :apt, 'newrelic-sysmond'
  }

  provides 'nrsysmond-config'
end