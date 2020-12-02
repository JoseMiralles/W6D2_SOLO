class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |arg|
      self.class_eval("def #{arg};@#{arg};end")
      self.class_eval("def #{arg}=(val);@#{arg}=val;end")
    end
  end
end
