class Array
  def XOR(other)
    (other | self) - (other & self)
  end

  def ^(other)
    XOR(other)
  end
end

