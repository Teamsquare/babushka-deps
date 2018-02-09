dep 'nginx.auto_start', :nginx_prefix do
  requires 'nginx.src'.with(:nginx_prefix => nginx_prefix)

  met? { "/etc/init.d/nginx".p.exists? }
  meet do
    render_erb 'nginx/nginx.init.d.erb', :to => '/etc/init.d/nginx', :perms => '755', :sudo => true
  end
end

dep 'nginx.src', :nginx_prefix, :version, :upload_module_version do
  nginx_prefix.default!("/usr/local/nginx")
  version.default!('1.13.8')
  upload_module_version.default!('2.2.0')
  requires 'pcre.managed', 'libssl headers.managed', 'zlib headers.managed'
  source "http://nginx.org/download/nginx-#{version}.tar.gz"
  extra_source "https://github.com/vkholodkov/nginx-upload-module/archive/#{upload_module_version}.tar.gz"
  configure_args "--with-ipv6", "--with-pcre", "--with-http_ssl_module", "--with-http_gzip_static_module"
    "--add-module='../../nginx_upload_module-#{upload_module_version}/nginx_upload_module-#{upload_module_version}'"
  prefix nginx_prefix
  provides nginx_prefix / 'sbin/nginx'

  configure { log_shell "configure", default_configure_command }
  build { log_shell "build", "make" }
  install { log_shell "install", "make install", :sudo => true }

  met? {
    if !File.executable?(nginx_prefix / 'sbin/nginx')
      log "nginx isn't installed"
    else
      installed_version = shell(nginx_prefix / 'sbin/nginx -v') {|shell| shell.stderr }.val_for(/(nginx: )?nginx version:/).sub('nginx/', '')
      (installed_version == version).tap {|result|
        log "nginx-#{installed_version} is installed"
      }
    end
  }
end
