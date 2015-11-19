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
