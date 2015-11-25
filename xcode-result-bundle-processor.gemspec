# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xcoderesultbundleprocessor/version'

Gem::Specification.new do |spec|
  spec.name        = 'xcode-result-bundle-processor'
  spec.version     = XcodeResultBundleProcessor::VERSION
  spec.authors     = ['Manuel Wudka-Robles']
  spec.email       = ['mwudka@me.com']
  spec.summary     = %q{xcode-result-bundle-processor converts Xcode test result bundles into friendly HTML reports}
  spec.homepage    = ''
  spec.license     = 'mit'

  spec.files         = `git ls-files -z`.split("\x0").reject { |file| file =~ %r{^(test|spec|features)/} }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency('bundler', '~> 1.6')
  spec.add_development_dependency('rake', '~> 10.4')
  spec.add_development_dependency('rdoc', '~> 4.2')
  spec.add_development_dependency('aruba', '~> 0.10')
  spec.add_development_dependency('rspec', '~> 3.3')
  spec.add_development_dependency('codeclimate-test-reporter', '~> 0.4')

  spec.add_dependency('methadone', '~> 1.9.2')
  spec.add_dependency('awesome_print', '~> 1.6')
  spec.add_dependency('markaby', '~> 0.8')
  spec.add_dependency('CFPropertyList', '~> 2.2')
end
