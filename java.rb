dep 'jre' do
  requires 'jre.ppa', 'oracle-java7-installer.managed'
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

dep 'oracle-java7-installer.managed' do
  provides 'java'
end