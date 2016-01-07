dep 'jdk', :major_version do
  major_version.default!(8)

  requires 'jdk.ppa', 'agreed to java license'

  if major_version == 8
    requires 'oracle-java8-installer.managed'
  end

  if major_version == 7
    requires 'oracle-java7-installer.managed'
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
dep 'jdk.ppa' do
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

dep 'oracle-java7-installer.managed' do
  provides 'java'
end

dep 'oracle-java8-installer.managed' do
  provides 'java'
end
