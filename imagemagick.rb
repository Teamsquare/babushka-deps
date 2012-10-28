dep 'imagemagick.managed' do
  installs {
    %w(libmagickwand-dev imagemagick)
  }
  provides 'convert'
end