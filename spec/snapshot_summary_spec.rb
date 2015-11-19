module XcodeResultBundleProcessor
  describe SnapshotSummary do
    describe '#element_class' do
      it 'returns nil if not provided' do
        summary = SnapshotSummary.parse({})

        expect(summary.element_class).to be_nil
      end

      it 'returns class from additional attributes' do
        summary = SnapshotSummary.parse({additionalAttributes: {
            5004.to_s.to_sym => 'UISomeClass'
        }})

        expect(summary.element_class).to eq('UISomeClass')
      end
    end

    describe '#summary' do
      it 'is correct if nothing present' do
        summary = SnapshotSummary.parse({})

        expect(summary.summary).to eq('UnknownElement')
      end

      it 'is correct if only class name present' do
        summary = SnapshotSummary.parse({additionalAttributes: {
            5004.to_s.to_sym => 'UISomeClass'
        }})

        expect(summary.summary).to eq('UISomeClass')
      end

      it 'is correct if label present' do
        summary = SnapshotSummary.parse({label: 'SomeLabel'})

        expect(summary.summary).to eq('UnknownElement label=SomeLabel')
      end

      it 'is correct if title present' do
        summary = SnapshotSummary.parse({title: 'SomeTitle'})

        expect(summary.summary).to eq('UnknownElement title=SomeTitle')
      end

      it 'is correct if identifier present' do
        summary = SnapshotSummary.parse({identifier: 'SomeIdentifier'})

        expect(summary.summary).to eq('UnknownElement identifier=SomeIdentifier')
      end

      it 'is correct if value present' do
        summary = SnapshotSummary.parse({value: 'SomeValue'})

        expect(summary.summary).to eq('UnknownElement value=SomeValue')
      end

      it 'is correct if frame present' do
        summary = SnapshotSummary.parse({frame: '{{0, 0}, {375, 667}}'})

        expect(summary.summary).to eq('UnknownElement {{0, 0}, {375, 667}}')
      end

      it 'is correct if placeholder present' do
        summary = SnapshotSummary.parse({placeholder: 'myplaceholder'})

        expect(summary.summary).to eq('UnknownElement placeholder=myplaceholder')
      end

      it 'is correct if focused' do
        summary = SnapshotSummary.parse({hasFocus: true})

        expect(summary.summary).to eq('UnknownElement focused')
      end

      it 'is correct if keyboard focused' do
        summary = SnapshotSummary.parse({hasKeyboardFocus: true})

        expect(summary.summary).to eq('UnknownElement keyboardFocused')
      end

      it 'is correct if selected' do
        summary = SnapshotSummary.parse({selected: true})

        expect(summary.summary).to eq('UnknownElement selected')
      end

      it 'is correct if disabled' do
        summary = SnapshotSummary.parse({enabled: false})

        expect(summary.summary).to eq('UnknownElement disabled')
      end
    end

    describe '#children' do
      it 'returns empty array if nil children' do
        summary = SnapshotSummary.parse({})

        expect(summary.children).to eq([])
      end

      it 'returns empty array if no children' do
        summary = SnapshotSummary.parse(children: [])

        expect(summary.children).to eq([])
      end

      it 'returns children summary ' do
        summary = SnapshotSummary.parse({children: [{additionalAttributes: {
            5004.to_s.to_sym => ' UISomeClass '
        }}]})

        expect(summary.children.map(&:element_class)).to eq([' UISomeClass '])
      end
    end
  end

end