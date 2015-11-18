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

        info 'Deserializing logs'
        action_logs = LogDeserializer.deserialize_action_logs(@results_bundle)
        debug action_logs


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
            unless tests.failed_tests.empty?
              h1 'Failed Tests :('
              ul do
                tests.failed_tests.each do |failed_test|
                  li do
                    a href: "##{failed_test.identifier}" do
                      failed_test.identifier
                    end
                  end
                end
              end
            end

            h1 'Test Timelines'
            tests.tests.each do |test|
              _format_test(test, mab, destination_dir)
            end

            hr

            h1 'Action Logs'
            pre action_logs

          end
        end

        FileUtils.copy(@stylesheet_path, File.join(destination_dir, 'report.css'))
        File.open(File.join(destination_dir, 'index.html'), 'w').write(report)
      end

      def _format_test(test, mab, destination_dir)
        mab.a name: test.identifier do
          if test.passed?
            mab.h2 test.summary
          else
            mab.h2.testFailed test.summary
          end
        end

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

                          unless subactivity.snapshot_path.nil?
                            @results_bundle.open_file(File.join('Attachments', subactivity.snapshot_path)) do |file|
                              snapshot_plist   = CFPropertyList::List.new(data: file.read)
                              element_snapshot = ElementSnapshot.new(snapshot_plist)

                              snapshot_summary = SnapshotSummary.parse(element_snapshot.to_h)

                              _format_element_summary(mab, snapshot_summary)
                            end
                          end

                          ''
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

      def _format_element_summary(mab, element_summary)
        mab.ul do
          mab.li do
            span element_summary.summary

            element_summary.children.each do |child|
              _format_element_summary(mab, child)
            end
            ''
          end
        end
      end
    end
  end
end