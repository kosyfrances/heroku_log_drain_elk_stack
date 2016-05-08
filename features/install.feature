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
    Then it should be successful
    And heroku logstash conf file should be added
