dep 'bitbucket', :version, :install_prefix, :home_directory do
  version.default!('4.3.2')
  install_prefix.default!('/usr/local/bitbucket')
  home_directory.default!('/etc/bitbucket')

  product_name = 'bitbucket'

  requires [
               'jdk',
               'git',
               'atlassian.user_exists',
               'bitbucket.installed'.with(product_name, version, install_prefix, "atlassian-bitbucket-#{version}.tar.gz"),
               'bitbucket.home_directory_set'.with(install_prefix, home_directory),
               'atlassian.permissions'.with(install_prefix, home_directory, product_name)
           ]
end

# This is pretty much the same as `atlassian.product.installed` but
# the URL used to download the tar.gz has the old folder structure
# for Stash, so can't use `product_name`.
dep 'bitbucket.installed', :product_name, :version, :install_prefix, :remote_file_name do
  install_prefix.default!('/usr/local/atlassian')

  setup do
    must_be_root
  end

  met? do
    "#{install_prefix}/#{product_name}".p.exists?
  end

  meet do
    shell "mkdir -p #{install_prefix}"
    shell "wget https://www.atlassian.com/software/stash/downloads/binary/#{remote_file_name} -P /tmp"
    shell "tar xvf /tmp/#{remote_file_name} -C #{install_prefix}"
    shell "mv #{install_prefix}/*#{product_name}* #{install_prefix}/#{product_name}"
    shell "rm /tmp/#{remote_file_name}"
  end
end

dep 'bitbucket.home_directory_set', :install_prefix, :home_directory do
  setup do
    must_be_root
  end

  met? do
    "#{install_prefix}/bin/setenv.sh".p.grep(/#{home_directory}/)
  end

  meet do
    shell "mkdir -p #{home_directory}"
    shell "sed -i s/export BITBUCKET_HOME=/export BITBUCKET_HOME=\"#{home_directory.to_str.gsub('/', '\/')}\"\/ #{install_prefix.to_str.gsub('/', '\/')}\/bin\/setenv.sh"
  end

  dep 'bitbucket.shared_config', :home_directory, :install_prefix do
    setup do
      must_be_root
    end

    met? do
      "#{home_directory}/shared/server.xml".p.exists?
    end

    meet do
      shell "cp #{install_prefix}/conf/server.xml #{home_directory}/shared/"
    end
  end
end
