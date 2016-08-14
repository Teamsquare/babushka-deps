dep 'atlassian.product', :product_name, :version, :install_prefix, :home_directory, :username, :jdk_version do
  home_directory.default!("/etc/#{product_name}")
  username.default!('atlassian')
  jdk_version.default!(8)

  requires [
    'jdk'.with(jdk_version),
    'atlassian.user_exists'.with(username),
    'atlassian.product.installed'.with(:product_name, :version, :install_prefix)
  ]
end

dep 'atlassian.product.installed', :product_name, :version, :install_prefix, :remote_file_name do
  install_prefix.default!('/usr/local/atlassian')

  setup do
    must_be_root
  end

  met? do
    "#{install_prefix}/#{product_name}".p.exists?
  end

  meet do
    shell "mkdir -p #{install_prefix}"
    shell "wget https://www.atlassian.com/software/#{product_name}/downloads/binary/#{remote_file_name} -P /tmp"
    shell "tar xvf /tmp/#{remote_file_name} -C #{install_prefix}"
    shell "mv #{install_prefix}/*#{product_name}* #{install_prefix}/#{product_name}"
    shell "rm /tmp/#{remote_file_name}"
  end
end

dep 'atlassian.product.home_directory_set', :product_name, :install_prefix, :home_directory do
  setup do
    must_be_root
  end

  met? do
    "#{install_prefix}/#{product_name}/atlassian-#{product_name}/WEB-INF/classes/#{product_name}-application.properties".p.grep(/#{home_directory}/)
  end

  meet do
    shell "mkdir -p #{home_directory}"
    shell "echo '#{product_name}.home=#{home_directory}' > #{install_prefix}/#{product_name}/atlassian-#{product_name}/WEB-INF/classes/#{product_name}-application.properties"
  end
end

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

dep 'atlassian.user_exists', :user_name, :group_name do
  user_name.default!('atlassian')
  group_name.default!(user_name)

  requires 'user and group exist'.with(user_name, group_name)
end
