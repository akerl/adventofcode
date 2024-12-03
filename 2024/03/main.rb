puts File.read('input').scan(/mul\(\d{1,3},\d{1,3}\)/).map { |x| x.gsub(/[mul()]/, '').split(',').map(&:to_i).reduce(:*) }.sum

inst = File.read('input').scan(/(mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\))/).map(&:first)
res = inst.each_with_object([true, 0]) do |item, obj|
  case item
  when 'do()'
    obj[0] = true
  when "don't()"
    obj[0] = false
  else
    obj[1] += item.gsub(/[mul()]/, '').split(',').map(&:to_i).reduce(:*) if obj[0]
  end
end

puts res.last
