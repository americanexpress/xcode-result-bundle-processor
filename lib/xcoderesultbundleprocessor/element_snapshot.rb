module XcodeResultBundleProcessor
  class ElementSnapshot < OpenStruct
    def initialize(plist)
      super()

      @objects = plist.value.value['$objects'].value

      root_object = plist.value.value['$top'].value['root']

      self._deserialize_object(root_object).each do |key, value|
        self[key] = value
      end
    end

    def _deserialize_dictionary(cfdictionary)
      if cfdictionary.value.key?('NS.rectval')
        return self._deserialize_object(cfdictionary.value['NS.rectval'])
      end

      if cfdictionary.value.key?('$classname')
        return cfdictionary.value['$classname'].value
      end

      ret = {}
      if cfdictionary.value.key?('NS.keys') && cfdictionary.value.key?('NS.objects')
        keys_and_values = cfdictionary.value['NS.keys'].value.zip(cfdictionary.value['NS.objects'].value)
        keys_and_values.each do |key, value|
          ret[self._deserialize_object(key)] = self._deserialize_object(value)
        end
      elsif cfdictionary.value.key?('NS.objects')
        return cfdictionary.value['NS.objects'].value.map { |o| self._deserialize_object(o) }
      else
        cfdictionary.value.each do |key, value|
          ret[key] = self._deserialize_object(value)
        end

      end
      ret
    end

    def _deserialize_object(object)
      if object.is_a?(CFPropertyList::CFUid)
        self._deserialize_object(@objects[object.value])
      elsif object.is_a?(CFPropertyList::CFString) && object.value == '$null'
        nil
      elsif object.is_a?(CFPropertyList::CFDictionary)
        self._deserialize_dictionary(object)
      elsif object.is_a?(CFPropertyList::CFString) or object.is_a?(CFPropertyList::CFInteger) or object.is_a?(CFPropertyList::CFBoolean)
        object.value
      elsif object.is_a?(CFPropertyList::CFArray)
        object.value.map { |o| self._deserialize_object(o) }
      else
        raise "Unsupported object type #{object.class}"
      end
    end

    def _deserialize_uid(uid)
      object = @objects[uid.value]

      if object.is_a?(CFPropertyList::CFUid)
        _deserialize_uid(uid)
      elsif object.is_a?(CFPropertyList::CFString) && object.value == '$null'
        nil
      elsif object.is_a?(CFPropertyList::CFDictionary)
        hash = {}

        object.value.each do |key, value|
          if value.is_a?(CFPropertyList::CFUid)
            hash[key] = self._deserialize_uid(value)
          else
            hash[key] = value.value
          end
        end

        hash
      else
        object.value
      end
    end
  end
end
