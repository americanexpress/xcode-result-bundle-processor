[![Build Status](https://travis-ci.org/americanexpress/xcode-result-bundle-processor.svg?branch=master)](https://travis-ci.org/americanexpress/xcode-result-bundle-processor)
[![Code Climate](https://codeclimate.com/github/americanexpress/xcode-result-bundle-processor/badges/gpa.svg)](https://codeclimate.com/github/americanexpress/xcode-result-bundle-processor)
[![Test Coverage](https://codeclimate.com/github/americanexpress/xcode-result-bundle-processor/badges/coverage.svg)](https://codeclimate.com/github/americanexpress/xcode-result-bundle-processor/coverage)
[![Issue Count](https://codeclimate.com/github/americanexpress/xcode-result-bundle-processor/badges/issue_count.svg)](https://codeclimate.com/github/americanexpress/xcode-result-bundle-processor)

# XcodeResultBundleProcessor

This tool converts into Xcode 7's machine-readable results bundle into a human-readable HTML report including
detailed activity logs and screenshots for UI tests.

## Installation

Add this line to your application's Gemfile:

    gem 'xcode-result-bundle-processor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xcode-result-bundle-processor

## Usage

First, run your UI tests using an invocation like this:

    xcodebuild -workspace MyWorkspace.xcworkspace \
        -scheme 'My UI Tests' \
        -sdk iphonesimulator \
        -resultBundlePath "my_results_bundle" \
        
This will put a bunch of mystery files into `my_results_bundle`, which you can transform into un-mystery files
via

    bundle exec xcode-result-bundle-processor --save-html-report report my_results_bundle 
    
The report will appear in `report/index.html`

## Development

If you have RVM and change to the working directory, you'll be prompted to install the needed Ruby version if you
don't already have it. RVM will also handle creating a gemset.

To update the dependencies, run

    bundle
    
To run tests, run

    bundle exec rake

To build the gem, fun
    
    bundle exec rake build
    
To execute the tool, run

    bundle exec xcode-result-bundle-processor

## Contributing

Contributing is easy and fun! Some guidelines:

* If you're making a non-trivial change, consider reaching out to Manuel the Maintainer (mwudka@me.com) for an
 architecture/implementation chat.
* Create an issue to track your work and describe your goals
* Branch from master and make your changes in the branch
* Add tests for any new functionality
* When you're happy with your changes and the builds pass, open a PR
* If no one has addressed your PR after a day or two, prod Manuel the Maintainer (mwudka@me.com)