# python-web-dev-box
Get a Python (web) development environment up-and-running quickly through the
powerful and wonderful [Vagrant](http://vagrantup.com) and [Chef-Solo](http://vagrantup.com/v1/docs/provisioners/chef_solo.html).

## Usage
1. Install Vagrant.
2. Clone this repository: `git clone https://github.com/kfr2/python-web-dev-box`
3. `cd python-web-dev-box`
4. `git submodule init`
5. `git submodule update`
6. Copy your project's files into `projects`.  You may want to use a symbolic
   link instead.
7. Update `sql-dump-uri.txt` to contain the URI of a SQL dump to load into the server's database upon provisioning.  Alternatively, you may copy the dump file into `provisioning/initial.sql`.  If you do not wish for initial loading of data, create `.initial_db_loaded` within this project's root directory.
8. Modify provisioning files/Chef recipes as necessary.
9. Ascertain `project/requirements/dev.txt` and `project/requirements/prod.txt`
   include any necessary Python packages.  They will be installed during provisioning.
10. Run `vagrant up`
11. Wait a number of minutes while the VM loads and provisioning occurs.
12. Run `vagrant ssh`
13. ???
14. Profit!

## What's Included?
* apt
* build-essential
* zsh
* openssl
* git
* python
* virtualenv
* pip
* postgresql (server & client)
* memcached


# License
This project is released under the MIT License.  Please see `LICENSE` for more information.

## Thanks
This project is based off Julien Phalip's [djangoproject.com fork](https://github.com/jphalip/djangoproject.com/tree/vagrant) (vagrant branch).  It furthermore appropriates components from [Rogelio Castillo's vagrant-postgrelsql](https://github.com/rogelio2k/vagrant-postgresql).
