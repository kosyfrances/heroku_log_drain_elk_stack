Feature: Provision and Install

  Background:
    Given I have a running server
    And I provision it

  Scenario: Install elasticsearch
    When I install elasticsearch
    Then it should be successful
    And elasticsearch should be running
    And it should be accepting connections on port 9200

  Scenario: Install logstash
    When I install logstash
    Then it should be successful
    And logstash should be running

  Scenario: Install kibana
    When I install kibana
    Then it should be successful
    And kibana should be running
    And it should be accepting connections on port 5601

  Scenario: Create logstash directory
    When I create a logstash directory
    Then conf.d directory should exist
    And heroku logstash conf file should be added
    And heroku logstash conf file should be present

  Scenario: Install nginx
    When I install nginx
    Then it should be successful
    And nginx should be running
    And it should be accepting connections on port 80

  Scenario: Set up SSL
    When I create the ssl directory in nginx
    Then SSL directory should exist
    Then I should create an SSL certificate
    And the key file should exist
    And the certificate should exist
    And nginx should be running
