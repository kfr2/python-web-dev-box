# Set up virtualenvwrapper ---------------------------------------------------

python_pip "virtualenvwrapper" do
  action :install
  not_if "test -e /usr/local/bin/virtualenvwrapper.sh"
end

bash "Configure virtualenvwrapper" do
  user "vagrant"
  code <<-EOH
  echo "export WORKON_HOME=/home/vagrant/.virtualenvs" >> /home/vagrant/.profile
  echo "source /usr/local/bin/virtualenvwrapper.sh" >> /home/vagrant/.profile
  echo "workon python-web-dev" >> /home/vagrant/.profile
  echo "cd /boxhome" >> /home/vagrant/.profile
  EOH
  not_if "cat /home/vagrant/.profile | grep virtualenvwrapper.sh"
end


# Create the virtual environment ---------------------------------------------

python_virtualenv "/home/vagrant/.virtualenvs/python-web-dev" do
  interpreter "python2.6"
  owner "vagrant"
  action :create
  not_if "test -d /home/vagrant/.virtualenvs/python-web-dev"
end

bash "Initial loading of virtualenv requirements" do
  user "vagrant"
  code <<-EOH
  source /home/vagrant/.profile
  source /home/vagrant/.virtualenvs/python-web-dev/bin/activate
  cd /boxhome
  pip install -r project/requirements/local.txt
  pip install -r project/requirements/deploy.txt
  touch /home/vagrant/.requirements_loaded
  EOH
  not_if "test -e /home/vagrant/.requirements_loaded"
end


# Create the database --------------------------------------------------------

bash "Create database and its user" do
  user "vagrant"
  code <<-EOH
  # Recreate the cluster so it uses UTF-8
  sudo -u postgres pg_dropcluster --stop 8.4 main
  sudo -u postgres pg_createcluster --start -e UTF-8 8.4 main
  # Create user and DB.
  echo "CREATE USER pythonproject WITH SUPERUSER PASSWORD 'secret';" | sudo -u postgres psql
  sudo -u postgres createdb -O pythonproject pythonproject
  EOH
  not_if "sudo -u postgres psql -l | grep pythonproject"
end

bash "Download initial data dump" do
  user "vagrant"
  code <<-EOH
  wget $(< /boxhome/sql-dump-uri.txt) -O /boxhome/provisioning/initial.sql
  EOH
  not_if "test -e /boxhome/provisioning/initial.sql"
end

bash "Load initial database data" do
  user "vagrant"
  code <<-EOH
  sudo -u postgres psql -d pythonproject < /boxhome/provisioning/initial.sql
  touch /home/vagrant/.initial_db_loaded
  EOH
  not_if "test -e /home/vagrant/.initial_db_loaded"
end
