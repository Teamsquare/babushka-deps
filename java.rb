dep 'jre', :major_version do
  major_version.default!(7)

  requires 'jre.ppa', 'agreed to java license'

  if major_version == 7
    requires 'oracle-java7-installer.managed'
  end

  if major_version == 6
    requires 'oracle-java6-installer.managed'
  end
end

dep 'agreed to java license' do
  met? do
    '~/java-license-accepted'.p.exists?
  end
  meet {
    shell "echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections"
    shell "echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections"
    shell 'touch ~/java-license-accepted'
  }
end
dep 'jre.ppa' do
  met? {
    "/etc/apt/sources.list.d/webupd8team-java-precise.list".p.exist?
  }
  meet do
    shell "add-apt-repository ppa:webupd8team/java"
  end
  after {
    shell "apt-get update"
  }
end

dep 'oracle-java6-installer.managed' do
  provides 'java'
end

dep 'oracle-java7-installer.managed' do
  provides 'java'
end

dep 'oracle.jdk.6u33' do
  met? do
    'java'.p.exists?
  end

  meet do
    shell 'wget --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk6-downloads-1637591.html;" http://download.oracle.com/otn-pub/java/jdk/6u33-b03/jdk-6u33-linux-x64.bin -P /tmp'
    shell "chmod +x /tmp/jdk-6u33-linux-x64.bin"
    shell "/tmp/jdk-6u33-linux-x64.bin"
    shell "rm -rf /tmp/jdk-6u33-linux-x64.bin"
  end
end