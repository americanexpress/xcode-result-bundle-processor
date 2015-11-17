module XcodeResultBundleProcessor
  module TestSummaries
    class HTMLReport
      include Methadone::CLILogging

      def initialize(results_bundle)
        @results_bundle  = results_bundle
        @stylesheet_path = 'report.css'
      end

      def save(destination_dir)
        info "Saving HTML report to #{destination_dir}"

        raise "Destination directory #{destination_dir} already exists" if Dir.exists?(destination_dir)

        FileUtils.mkdir_p(File.join(destination_dir, 'screenshots'))

        tests = TestSummaries.new(@results_bundle.read_plist('TestSummaries.plist'))

        debug "Formatting test summaries <#{tests.ai}>"

        Markaby::Builder.set_html5_options!
        Markaby::Builder.set(:indent, 2)
        mab    = Markaby::Builder.new({}, self)
        report = mab.html5 do
          head do
            link rel: 'stylesheet', href: 'report.css'
          end

          body do
            tests.tests.each do |test|
              _format_test(test, mab, destination_dir)
            end
          end
        end

        FileUtils.copy(@stylesheet_path, File.join(destination_dir, 'report.css'))
        File.open(File.join(destination_dir, 'index.html'), 'w').write(report)

      end

      def _format_test(test, mab, destination_dir)
        mab.h2 test.summary

        mab.ul do
          test.failure_summaries.each do |failure_summary|
            li do
              em "Failure at #{failure_summary.location}"
              pre failure_summary.message
            end
          end
          ''
        end

        mab.div.timelineContainer do
          table do
            tr do
              test.activities.each do |activity_summary|
                td do
                  h4 activity_summary.title

                  table do
                    tr do
                      activity_summary.subactivities.each do |subactivity|
                        td do
                          h5 subactivity.title

                          unless subactivity.screenshot_path.nil?
                            basename = File.basename(subactivity.screenshot_path)

                            output_image_path = File.join(destination_dir, 'screenshots', basename)
                            @results_bundle.copy_file(File.join('Attachments', subactivity.screenshot_path), output_image_path)

                            img src: File.join('screenshots', basename)
                          end
                        end
                      end
                      ''
                    end
                  end
                end
              end
              ''
            end
          end
        end
        ''
      end
    end
  end
end