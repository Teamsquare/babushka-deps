def must_be_root
  unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
end

