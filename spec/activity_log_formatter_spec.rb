module XcodeResultBundleProcessor
  RSpec.describe ActivityLogFormatter do
    describe '#format' do

      it 'returns correct section' do
        subsection = SLF0::Model::IDEActivityLogSection.new(title: 'Inner title', text: 'Inner text')
        section    = SLF0::Model::IDEActivityLogSection.new(title: 'Test title', text: 'Test text', subsections: [subsection])

        expected = [
            'Inner title',
            'Inner text'
        ].join("\n") + "\n"

        expect(ActivityLogFormatter.format(section)).to eq(expected)
      end

      it 'returns newline for nil' do
        expect(ActivityLogFormatter.format(nil)).to eq("\n")
      end

    end
  end
end