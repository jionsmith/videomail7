HDFVR.reduce("donot=removethis") do |memo, (key, value)|
  memo = "#{memo}&#{key}=#{value}"
end
