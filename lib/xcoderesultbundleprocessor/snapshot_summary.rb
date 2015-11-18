module XcodeResultBundleProcessor
  class SnapshotSummary < KeywordStruct.new(:element_class, :children, :identifier, :title, :label, :value, :frame, :placeholder, :focused?, :keyboardFocused?, :selected?, :enabled?)

    def self.parse(element_snapshot)
      element_class = nil
      if element_snapshot.key?(:additionalAttributes) and element_snapshot[:additionalAttributes].key?(5004)
        element_class = element_snapshot[:additionalAttributes][5004]
      end

      SnapshotSummary.new(
          element_class:    element_class,
          children:         Array(element_snapshot[:children]).map { |child| SnapshotSummary.parse(child) },
          identifier:       element_snapshot[:identifier],
          title:            element_snapshot[:title],
          label:            element_snapshot[:label],
          value:            element_snapshot[:value],
          frame:            element_snapshot[:frame],
          placeholder:      element_snapshot[:placeholder],
          focused?:         !!element_snapshot[:hasFocus],
          keyboardFocused?: !!element_snapshot[:hasKeyboardFocus],
          selected?:        !!element_snapshot[:selected],
          enabled?:         element_snapshot[:enabled] != false,
      )

    end

    def to_s
      summary_components = [
          self.element_class || 'UnknownElement',
          self.frame
      ]

      summary_components += [:identifier, :title, :label, :value, :placeholder].map do |attribute|
        unless self[attribute].nil?
          "#{attribute}=#{self[attribute]}"
        end
      end

      summary_components << 'focused' if self.focused?
      summary_components << 'keyboardFocused' if self.keyboardFocused?
      summary_components << 'selected' if self.selected?
      summary_components << 'disabled' unless self.enabled?

      summary_components.compact.join(' ')
    end
  end
end