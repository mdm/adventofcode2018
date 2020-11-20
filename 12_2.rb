require 'pp'
require 'set'

current_state = gets.split[2]
current_offset = 0
removed = 0
gets

rules = {}
while rule = gets
    parts = rule.split
    rules[parts[0]] = parts[2]
end

seen = Set.new
200.times do |n|
    seen.add(current_state)
    pp [n, current_state.size] if n % 1000000 == 0
    current_state = '....' + current_state + '....'
    next_state = ''
    (current_state.size - 4).times do |i|
        next_state += rules[current_state[i..(i + 4)]]
    end

    tmp = next_state.chars
    before = tmp.size
    tmp = tmp.drop_while { |char| char == '.' }
    after = tmp.size
    tmp = tmp.reverse.drop_while { |char| char == '.' }
    current_state = tmp.reverse.join
    current_offset += 2
    removed += before - after
    if seen.include?(current_state)
        puts 'repeats after'
        pp [n + 1, removed]
        break
    end
end

sum = 0
current_state.chars.each_with_index do |pot, i|
    sum += (removed * 50000000000 / 123) + i - current_offset if pot == '#'
end

puts sum
