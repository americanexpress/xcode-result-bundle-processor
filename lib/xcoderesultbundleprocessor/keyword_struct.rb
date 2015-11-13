module XcodeResultBundleProcessor

  class KeywordStruct < Struct
    def initialize(*args, **kwargs)
      super()
      param_hash = kwargs.any? ? kwargs : Hash[members.zip(args)]
      param_hash.each { |k, v| self[k] = v }
    end
  end
end