require 'open3'

Given(/^I have a running server$/) do
    output, error, status = Open3.capture3 "unset RUBYLIB; vagrant reload"

    expect(status.success?).to eq(true)
end

And(/^I provision it$/) do
    output, error, status = Open3.capture3 "unset RUBYLIB; vagrant provision"

    expect(status.success?).to eq(true)
end

When(/^I install elasticsearch$/) do
    cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elk.yml --tags 'elasticsearch_setup'"

    output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^it should be successful$/) do
    expect(@status.success?).to eq(true)
end

# This is for elasticsearch, logstash and kibana
And(/^([^"]*) should be running$/) do |pkg|
    case pkg
    when 'elasticsearch', 'logstash', 'kibana', 'nginx'
        output, error, status = Open3.capture3 "unset RUBYLIB; vagrant ssh -c 'sudo service #{pkg} status'"

        expect(status.success?).to eq(true)
        expect(output).to match("#{pkg} is running")
    else
        raise 'Not Implemented'
    end
end

And(/^it should be accepting connections on port ([^"]*)$/) do |port|
    output, error, status = Open3.capture3 "unset RUBYLIB; vagrant ssh -c 'curl -f http://localhost:#{port}'"

    expect(status.success?).to eq(true)
end

When(/^I install logstash$/) do
    cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elk.yml --tags 'logstash_setup'"
    output, error, @status = Open3.capture3 "#{cmd}"
end

When(/^I install kibana$/) do
   cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elk.yml --tags 'kibana_setup'"
   output, error, @status = Open3.capture3 "#{cmd}"
end

When(/^I create a logstash directory$/) do
   cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elk.yml --tags 'logstash_dir'"
    output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^conf.d directory should exist$/) do
  output, error, status = Open3.capture3 "unset RUBYLIB; vagrant ssh -c 'ls /etc/logstash/ | grep conf.d'"

  expect(output).to match("conf.d")
end

And(/^heroku logstash conf file should be added$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elk.yml --tags 'conf_file'"
    output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^heroku logstash conf file should be present$/) do
    output, error, status = Open3.capture3 "unset RUBYLIB; vagrant ssh -c 'ls /etc/logstash/conf.d | grep heroku.conf'"

    expect(output).to match("heroku.conf")
end

When(/^I install nginx$/) do
    cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elk.yml --tags 'nginx_setup'"

    output, error, @status = Open3.capture3 "#{cmd}"
end

When(/^I create the ssl directory in nginx$/) do
    cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elk.yml --tags 'ssl_dir'"

    output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^SSL directory should exist$/) do
   output, error, status = Open3.capture3 "unset RUBYLIB; vagrant ssh -c 'ls /etc/nginx | grep ssl'"

    expect(output).to match("ssl")
end

Then(/^I should create an SSL certificate$/) do
   cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elk.yml --tags 'ssl_cert'"

    output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^the key file should exist$/) do
  output, error, status = Open3.capture3 "unset RUBYLIB; vagrant ssh -c 'ls /etc/nginx/ssl/ | grep server.key'"

  expect(output).to match("server.key")
end

Then(/^the certificate should exist$/) do
  output, error, status = Open3.capture3 "unset RUBYLIB; vagrant ssh -c 'ls /etc/nginx/ssl/ | grep server.crt'"

  expect(output).to match("server.crt")
end

When(/^I install apacheutils$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elk.yml --tags 'apache2_utils_setup'"

  output, error, @status = Open3.capture3 "#{cmd}"
end

When(/^I install python passlib$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elk.yml --tags 'passlib_setup'"

  output, error, @status = Open3.capture3 "#{cmd}"
end

When(/^I create htpasswd user and password$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elk.yml --tags 'kibana.htpassword'"

  output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^kibanahtpasswd file should exist$/) do
  output, error, status = Open3.capture3 "unset RUBYLIB; vagrant ssh -c 'ls /etc/nginx/conf.d/ | grep kibana.htpasswd'"

  expect(output).to match("kibana.htpasswd")
end

When(/^I create kibana write htpassword$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elk.yml --tags 'kibanawrite.htpassword'"

  output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^kibanawritehtpasswd file should exist$/) do
  output, error, status = Open3.capture3 "unset RUBYLIB; vagrant ssh -c 'ls /etc/nginx/conf.d/ | grep kibana-write.htpasswd'"

  expect(output).to match("kibana-write.htpasswd")
end

When(/^I copy sites available default for kibana$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elk.yml --tags 'kibana_sites_available'"

  output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^kibana file should exist in sites available$/) do
  output, error, status = Open3.capture3 "unset RUBYLIB; vagrant ssh -c 'ls /etc/nginx/sites-available/ | grep kibana'"

  expect(output).to match("kibana")
end

Then(/^I should link the file to sites enabled$/) do
   cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elk.yml --tags 'kibana_symlink'"

  output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^kibana file should exist in sites enabled$/) do
  output, error, status = Open3.capture3 "unset RUBYLIB; vagrant ssh -c 'ls /etc/nginx/sites-enabled/ | grep kibana'"

  expect(output).to match("kibana")
end
