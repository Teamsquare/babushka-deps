dep 'kibana', :install_prefix do
  setup do
    must_be_root
  end

  met? do
    "#{install_prefix}/kibana/kibana.rb".p.exists?
  end

  meet do
    shell "curl -L http://github.com/rashidkpc/Kibana/tarball/kibana-ruby -P /tmp | tar -xz"
    shell "mv *Kibana* #{install_prefix}"
    shell "mv #{install_prefix}/*Kibana* #{install_prefix}/kibana"
    shell "rm -rf /tmp/*Kibana*"
  end
end