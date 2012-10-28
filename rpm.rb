dep 'rpm monitoring', :license_key do
  setup do
    must_be_root
  end

  requires [
    'new relic apt-get source registered',
    'new relic public key installed',
    'apt-get updated',
    'newrelic-sysmond.managed',
    'new relic configured'.with(license_key),
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
end

dep 'apt-get updated' do
  setup do
    must_be_root
  end
  meet do
    shell 'apt-get update'
  end
end

dep 'new relic configured', :license_key do
  setup do
    must_be_root
  end

  shell "nrsysmond-config --set license_key=#{license_key}"
end

dep 'new relic started' do
  setup do
    must_be_root
  end

  shell '/etc/init.d/newrelic-sysmond start'
end

def must_be_root
  unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
end