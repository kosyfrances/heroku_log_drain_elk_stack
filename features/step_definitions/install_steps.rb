require 'open3'

Given(/^I have a running server$/) do
  output, error, status = Open3.capture3 "vagrant reload"

  expect(status.success?).to eq(true)
end

Given(/^I provision it$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
