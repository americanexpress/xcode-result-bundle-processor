require 'xcoderesultbundleprocessor/activity_log_formatter'

RSpec.describe XcodeResultBundleProcessor::ActivityLogFormatter do
  describe '#format' do

    it 'returns correct section' do
      subsection = XcodeResultBundleProcessor::IDEActivityLogSection.new(title: 'Inner title', text: 'Inner text')
      section    = XcodeResultBundleProcessor::IDEActivityLogSection.new(title: 'Test title', text: 'Test text', subsections: [subsection])

      expected = [
          'Inner title',
          'Inner text'
      ].join("\n") + "\n"

      expect(XcodeResultBundleProcessor::ActivityLogFormatter.format(section)).to eq(expected)
    end

  end
end
