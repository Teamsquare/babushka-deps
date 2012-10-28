dep 'npm installed' do
  requires 'nodejs installed'

  meet do
    shell 'curl https://npmjs.org/install.sh | sudo sh'
  end
  
  provides 'npm'
end