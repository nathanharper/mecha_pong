function filter(array, func)
  local filtered = {}
  for _,v in ipairs(array) do
    if func(v) then
      filtered[#filtered+1] = v
    end
  end
  return filtered
end
