input = File.read('input').split("\n")

rules = input.grep(/\|/).map { |x| x.split('|') }
books = input.grep(/,/).map { |x| x.split(',') }

mapping = rules.each_with_object({}) { |item, acc| acc[item.first] ||= [] ; acc[item.first] << item.last }

def is_bad(book, mapping)
  prior = []
  book.any? { |y| prior << y ; (prior & mapping[y]).size > 0 }
end

good = books.reject { |x| is_bad(x, mapping) }

puts good.map { |x| x[(x.size-1)/2].to_i }.sum

def fix(book, mapping)
  b = book.clone
  m = mapping.clone
  m.transform_values! { |x| x.select { |y| b.include? y } }
  m.reject! { |k, v| v.empty? }
  good = []
  while b.size > 0 do
    i = b.index { |x| m[x].nil? }
    if i.nil?
      require 'pry'
      binding.pry
    end
    good.unshift b.delete_at(i)
    m.transform_values! { |x| x.reject { |y| y == good.first } }
    m.reject! { |k, v| v.empty? }
  end
  good
end

bad = books.select { |x| is_bad(x, mapping) }

fixed = bad.map { |x| fix(x, mapping) }

puts fixed.map { |x| x[(x.size-1)/2].to_i }.sum
