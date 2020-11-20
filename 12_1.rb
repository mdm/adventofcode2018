require 'pp'
require 'set'

initial_state = current_state = gets.split[2]
current_offset = 0
gets

rules = {}
while rule = gets
    parts = rule.split
    rules[parts[0]] = parts[2]
end

def display(state, offset)
    buffer = 100
    left = ['.'] * (buffer - offset)
    right = ['.'] * (buffer - offset)
    puts left.join + state + right.join
end

def strip_dots(state)
    state = state.gsub('.', ' ')
    state = state.strip
    state.gsub(' ', '.')
end

# pp rules
# display(current_state, current_offset)
seen = Set.new
500.times do |n|
    seen.add(strip_dots(current_state))
    current_state = '....' + current_state + '....'
    next_state = ''
    (current_state.size - 4).times do |i|
        # pp current_state[i..(i + 4)], rules[current_state[i..(i + 4)]]
        next_state += rules[current_state[i..(i + 4)]]
    end

    current_state = next_state
    current_offset += 2

    if strip_dots(current_state) == '#..#.##...#.##....#....#.##...#.....#.##...#.##...#.##...#.##...#..#.##...#.##...#.##...#.##...#.##...#.##...#.##...#.##...#.##...#.##...#.##'
        puts current_state
    end

    if seen.include?(strip_dots(current_state))
        puts 'loop ends on'
        pp [n + 1, current_offset]
        break
    end

    # display(current_state, current_offset)
end

sum = 0
current_state.chars.each_with_index do |pot, i|
    sum += (50000000000 - 123) + i - current_offset if pot == '#'
end

puts sum
