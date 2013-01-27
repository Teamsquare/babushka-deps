dep 'atlassian.permissions', :install_prefix, :home_directory, :app_name, :username do
  met? do
    output = shell?("stat #{install_prefix}/#{app_name} | grep Uid | grep #{username}")

    !output.nil?
  end

  meet do
    shell "chown -R #{username}:#{username} #{install_prefix}/#{app_name}/"
    shell "chown -R #{username}:#{username} #{home_directory}"
  end
end
