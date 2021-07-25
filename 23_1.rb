require 'pp'

bots = []
while bot = gets
    coords = bot[(bot.index('<') + 1)..(bot.index('>') - 1)].split(',').map { |coord| coord.to_i }
    radius = bot.split('=').last.to_i
    bots << [coords, radius]
end

# pp bots.size

max_radius = bots.map { |bot| bot[1] }.max
strongest_bot = bots.reject { |bot| bot[1] < max_radius }.first

# pp strongest_bot

def manhattan(bot_a, bot_b)
    (bot_a[0][0] - bot_b[0][0]).abs + (bot_a[0][1] - bot_b[0][1]).abs + (bot_a[0][2] - bot_b[0][2]).abs
end

in_range = bots.count { |bot| manhattan(bot, strongest_bot) <= max_radius }
puts in_range
