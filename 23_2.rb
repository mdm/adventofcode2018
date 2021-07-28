require 'pp'

bots = []
while bot = gets
    coords = bot[(bot.index('<') + 1)..(bot.index('>') - 1)].split(',').map { |coord| coord.to_i }
    radius = bot.split('=').last.to_i
    bots << [coords, radius]
end

bot_ranges = bots.map do |bot|
    [
        bot[1] + bot[0][0] + bot[0][1] + bot[0][2], # 0 opposite to 6
        bot[1] - bot[0][0] + bot[0][1] + bot[0][2], # 1 opposite to 7
        bot[1] - bot[0][0] - bot[0][1] + bot[0][2], # 2 opposite to 4
        bot[1] + bot[0][0] - bot[0][1] + bot[0][2], # 3 opposite to 5
        bot[1] + bot[0][0] + bot[0][1] - bot[0][2], # 4 opposite to 2
        bot[1] - bot[0][0] + bot[0][1] - bot[0][2], # 5 opposite to 3
        bot[1] - bot[0][0] - bot[0][1] - bot[0][2], # 6 opposite to 0
        bot[1] + bot[0][0] - bot[0][1] - bot[0][2], # 7 opposite to 1
    ]
end

def intersect?(ranges_a, ranges_b)
    axis_1 = -ranges_a[6] <= ranges_b[0] && -ranges_b[6] <= ranges_a[0]
    axis_2 = -ranges_a[7] <= ranges_b[1] && -ranges_b[7] <= ranges_a[1]
    axis_3 = -ranges_a[4] <= ranges_b[2] && -ranges_b[4] <= ranges_a[2]
    axis_4 = -ranges_a[5] <= ranges_b[3] && -ranges_b[5] <= ranges_a[3]

    axis_1 && axis_2 && axis_3 && axis_4
end

def inside?(ranges, x, y, z)
    result   =  x + y + z <= ranges[0]
    result &&= -x + y + z <= ranges[1]
    result &&= -x - y + z <= ranges[2]
    result &&=  x - y + z <= ranges[3]
    result &&=  x + y - z <= ranges[4]
    result &&= -x + y - z <= ranges[5]
    result &&= -x - y - z <= ranges[6]
    result &&=  x - y - z <= ranges[7]
end

max_in_range = 0
argmax_in_range = []
bot_ranges.each do |ranges_a|
    intersection = ranges_a
    in_range = 0
    bot_ranges.each do |ranges_b|
        if intersect?(intersection, ranges_b)
            intersection = [
                intersection[0] < ranges_b[0] ? intersection[0] : ranges_b[0],
                intersection[1] < ranges_b[1] ? intersection[1] : ranges_b[1],
                intersection[2] < ranges_b[2] ? intersection[2] : ranges_b[2],
                intersection[3] < ranges_b[3] ? intersection[3] : ranges_b[3],
                intersection[4] < ranges_b[4] ? intersection[4] : ranges_b[4],
                intersection[5] < ranges_b[5] ? intersection[5] : ranges_b[5],
                intersection[6] < ranges_b[6] ? intersection[6] : ranges_b[6],
                intersection[7] < ranges_b[7] ? intersection[7] : ranges_b[7],
            ]
            in_range += 1
        end
    end

    # pp ranges_a, intersection, in_range, inside?(intersection, 12, 12, 12)
    if in_range >= max_in_range
        max_in_range = in_range
        argmax_in_range << intersection
    end
end

# pp max_in_range, argmax_in_range
puts argmax_in_range[0].max
