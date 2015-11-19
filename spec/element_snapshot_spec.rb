module XcodeResultBundleProcessor
  describe ElementSnapshot do
    it do
      plist   = CFPropertyList::List.new(:file => 'features/fixtures/results_bundle_path/Attachments/Snapshot_15A6BDB2-C245-4D52-A8DC-F4679AB34D6A')
      element = ElementSnapshot.new(plist)

      expect(element[:hasFocus]).to be_falsey
      expect(element[:hasKeyboardFocus]).to be_falsey
      expect(element[:enabled]).to be_truthy
      expect(element[:isMainWindow]).to be_falsey
      expect(element[:selected]).to be_falsey
      expect(element[:parentAccessibilityElement]).to be_nil
      expect(element[:frame]).to eq('{{0, 0}, {375, 667}}')
      expect(element['$class'.to_sym]).to eq('XCElementSnapshot')
      expect(element[:accessibilityElement][:payload]).to eq({pid: 59497, 'uid.elementOrHash'.to_sym => 0, 'uid.elementID'.to_sym => 1})

      expect(element[:children].length).to eq(3)
      expect(element[:children].first[:children].first[:children].first[:frame]).to eq('{{0, -64}, {375, 44}}')
      expect(element[:children].first[:children].first[:children].first[:additionalAttributes][5004.to_s.to_sym]).to eq('UINavigationBar')
    end
  end
end