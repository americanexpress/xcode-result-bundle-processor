When(/^good things$/) do
  puts "What: #{expand_path('%/results_bundle_path')}"
end

When(/^I successfully process "([^"]*)"$/) do |results_bundle|
  results_bundle_path = expand_path("%/#{results_bundle}")
  step %(I successfully run `xcode-result-bundle-processor #{results_bundle_path}`)
end