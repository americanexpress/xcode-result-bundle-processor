[![Build Status](https://travis-ci.org/americanexpress/xcode-result-bundle-processor.svg?branch=master)](https://travis-ci.org/americanexpress/xcode-result-bundle-processor)
[![Code Climate](https://codeclimate.com/github/americanexpress/xcode-result-bundle-processor/badges/gpa.svg)](https://codeclimate.com/github/americanexpress/xcode-result-bundle-processor)
[![Test Coverage](https://codeclimate.com/github/americanexpress/xcode-result-bundle-processor/badges/coverage.svg)](https://codeclimate.com/github/americanexpress/xcode-result-bundle-processor/coverage)
[![Gem Version](https://badge.fury.io/rb/xcode-result-bundle-processor.svg)](https://badge.fury.io/rb/xcode-result-bundle-processor)
[![Dependency Status](https://www.versioneye.com/user/projects/565629adff016c002c001c2c/badge.svg?style=flat)](https://www.versioneye.com/user/projects/565629adff016c002c001c2c)

# What is XcodeResultBundleProcessor?

This tool converts into Xcode 7's machine-readable results bundle into a human-readable HTML report including
detailed activity logs and screenshots for UI tests.

# Installation

Add this line to your application's Gemfile:

    gem 'xcode-result-bundle-processor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xcode-result-bundle-processor

# Usage

First, run your UI tests using an invocation like this:

    xcodebuild -workspace MyWorkspace.xcworkspace \
        -scheme 'My UI Tests' \
        -sdk iphonesimulator \
        -resultBundlePath "my_results_bundle" \

This will put a bunch of mystery files into `my_results_bundle`, which you can transform into un-mystery files
via

    bundle exec xcode-result-bundle-processor --save-html-report report my_results_bundle

The report will appear in `report/index.html`

# Development

If you have RVM and change to the working directory, you'll be prompted to install the needed Ruby version if you
don't already have it. RVM will also handle creating a gemset.

To update the dependencies, run

    bundle

To run tests, run

    bundle exec rake

To build the gem, run

    bundle exec rake build

To execute the tool, run

    bundle exec xcode-result-bundle-processor

# Contributing

We welcome Your interest in the American Express Open Source Community on Github. Any Contributor to any Open Source Project managed by the American Express Open Source Community must accept and sign an Agreement indicating agreement to the terms below. Except for the rights granted in this Agreement to American Express and to recipients of software distributed by American Express, You reserve all right, title, and interest, if any, in and to Your Contributions. Please [fill out the Agreement](https://cla-assistant.io/americanexpress/).

# License

Any contributions made under this project will be governed by the [Apache License 2.0](https://github.com/americanexpress/xcode-result-bundle-processor/blob/master/LICENSE.txt).

# Code of Conduct

This project adheres to the [American Express Community Guidelines](https://github.com/americanexpress/middle-manager/wiki/Code-of-Conduct).
By participating, you are expected to honor these guidelines.
