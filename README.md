# Heroku ELK Log Drain

Heroku ELK Log Drain provides a central place where all the logs from heroku can go to. It was built with ELK stack - Elasticsearch, Logstash and Kibana - and tests written with Cucumber.

### Testing Locally
**Install the following on your mac:**

- VirtualBox: _brew cask install virtualbox_
- Vagrant: _brew cask install vagrant_
- Python: _brew install python_
- Ansible: _pip install ansible_
- Ruby: _brew install rbenv ruby-build_

Note that Ruby and Python are available by default on macs. Be sure to verify that.

If you are using rbenv, do this in the terminal.

```
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
source ~/.bash_profile
```
- Install Ruby
```
rbenv install 2.3.0
rbenv global 2.3.0
ruby -v
```

**Clone the project**
```
$ git clone https://github.com/andela-kanyanwu/heroku_log_drain_elk_stack.git
```

**Set it up**
```
$ cd heroku_log_drain_elk_stack/
$ vagrant up
$ vagrant ssh
```
- Update the variables in `vars.yml` file with your variables setting `host_user` to `vagrant` and `server_ip` to `192.168.33.10`. The username and password should be whatever you want.

Switch to another terminal in your local machine, not inside your VM, run
```
$ bundle install
$ cucumber features/install.feature
```
This runs all the tests and installs everything using ansible in your virtual machine.

Visit https://192.168.33.10 to check out kibana.

**To drain the logs from heroku, run this from your local machine**
```
$ heroku logs -t --app <YOUR_APP_NAME> | nc localhost 1514
```
Go back to kibana, select `Use event times to create index times`

This is the index pattern for heroku on Kibana - `[heroku-logs-]YYYY.MM.DD`

You should be able to see your logs on Kibana after that.

### Deploying to an EC2 Instance

**Set up the EC2 instance**

- Spin up an EC2 instance and ssh into it. Refer to AWS documentation for guidance.

**Install the following on your mac:**
- Ansible: _pip install ansible_

**Clone the project**
```
$ git clone https://github.com/andela-kanyanwu/heroku_log_drain_elk_stack.git
$ cd heroku_log_drain_elk_stack/
```
**Update settings in the repository locally**
- Look for `prod_inventory.ini` file in the root of the project and change the IP address on it to that of your EC2 instance.
- Look for `vars.yml` file in the root of the project and change the values of the variables to yours, where `host_user` is the name of the user account in the distro e.g _ubuntu_, `server_ip` is the IP address of your EC2 instance, username and password can be whatever you want.

**Run the project against the EC2 instance**
- Run the following in your local machine against the instance.
```
$ ansible-playbook -i prod_inventory.ini --private-key=<PATH TO YOUR PRIVATE KEY> -u ubuntu playbook.provision.yml

$ ansible-playbook -i prod_inventory.ini --private-key=<PATH TO YOUR PRIVATE KEY> -u ubuntu playbook.elk.yml
```

Visit https://YOUR_IP_ADDRESS to check out kibana.

**To add drain from heroku, run this from your local machine**
```
$ heroku drains:add https://YOUR_USERNAME:YOUR_PASSWORD@YOUR_INSTANCE_IP_ADDRESS/log -a <app_name>
```
Replace `YOUR_USERNAME` and `YOUR_PASSWORD` with your new username and password specified in the `vars.yml` file that you updated. Be sure to replace `<app_name>` with the name of your app on heroku.

Go back to kibana, select `Use event times to create index times`

This is the index pattern for heroku on Kibana - `[heroku-logs-]YYYY.MM.DD`

You should be able to see your logs on Kibana after that.
