class String
  def capitalized?
    self.capitalize == self
  end

  def pluralize
    self + "s"
  end
end

