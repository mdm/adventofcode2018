require 'pp'

bots = []
while bot = gets
    coords = bot[(bot.index('<') + 1)..(bot.index('>') - 1)].split(',').map { |coord| coord.to_i }
    radius = bot.split('=').last.to_i
    bots << [coords, radius]
end

pp bots.size

max_radius = bots.map { |bot| bot[1] }.max
strongest_bot = bots.reject { |bot| bot[1] < max_radius }.first

pp strongest_bot

def manhattan(bot_a, bot_b)
    (bot_a[0][0] - bot_b[0][0]).abs + (bot_a[0][1] - bot_b[0][1]).abs + (bot_a[0][2] - bot_b[0][2]).abs
end

in_range = bots.count { |bot| manhattan(bot, strongest_bot) <= max_radius }
puts in_range

x_coords = bots.map { |bot| bot[0][0] }
y_coords = bots.map { |bot| bot[0][1] }
z_coords = bots.map { |bot| bot[0][2] }

sizes = [x_coords.max -  x_coords.min, y_coords.max -  y_coords.min, z_coords.max -  z_coords.min]

pp sizes, sizes.reduce(:*)

candidates = bots.each_with_index.map { |bot, i| [i] }

bots.size.times do
    next_candidates = []
    candidates.each do |candidate|
        bots.each_with_index do |bot, bot_i|
            intersecting = candidate.all? do |candidate_bot|
                bot[1] + candidate_bot[1] >= manhattan(bot, candidate_bot)
            end
            if intersecting
                candidate << bot_i
                next_candidates << candidate
            end
        end
    end

    # break if next_candidates.size == candidates.size 
    pp next_candidates
    candidates = next_candidates
end
