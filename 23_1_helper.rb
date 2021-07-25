require 'pp'

def manhattan(coords_a, coords_b)
    (coords_a[0] - coords_b[0]).abs + (coords_a[1] - coords_b[1]).abs
end

def quadrant_pp(coords_a, coords_b)
    (coords_a[0] - coords_b[0]) + (coords_a[1] - coords_b[1])
end

def quadrant_pp_moved(coords_a, coords_b)
    coords_a[0] + coords_a[1]
end


grid = []
20.times { grid << ('.' * 20) }

bots = []
# bots << [[0, 0], 5]
bots << [[7, 7], 5]
bots << [[11, 10], 8]
20.times do |y|
    20.times do |x|
        covered = bots.count { |bot| manhattan([x, y], bot[0]) <= bot[1] }
        case covered
        when 0
            grid[y][x] = '.'
        when 1
            grid[y][x] = '+'
        when 2
            grid[y][x] = '#'
        end
    end
end


puts grid
puts


grid = []
20.times { grid << ('.' * 20) }

bots = []
# bots << [[0, 0], 5]
bots << [[0, 0], 3]
bots << [[0, 0], 5]
# bots << [[11, 10], 8]
half_planes = bots.map do |bot|
    [
        bot[1] + bot[0][0] + bot[0][1],
        bot[1] - bot[0][0] + bot[0][1],
        bot[1] - bot[0][0] - bot[0][1],
        bot[1] + bot[0][0] - bot[0][1],
    ]
end

intersection = if -half_planes[0][2] <= half_planes[1][0] && -half_planes[1][2] <= half_planes[0][0] && -half_planes[0][3] <= half_planes[1][1] && -half_planes[1][3] <= half_planes[0][1]
    [
        half_planes[0][0] < half_planes[1][0] ? half_planes[0][0] : half_planes[1][0],
        half_planes[0][1] < half_planes[1][1] ? half_planes[0][1] : half_planes[1][1],
        half_planes[0][2] < half_planes[1][2] ? half_planes[0][2] : half_planes[1][2],
        half_planes[0][3] < half_planes[1][3] ? half_planes[0][3] : half_planes[1][3],
    ]
end
pp intersection

half_planes << intersection

20.times do |y|
    20.times do |x|
        covered = half_planes.count { |half_plane| x + y <= half_plane[0] && -x + y <= half_plane[1] && -x - y <= half_plane[2] && x - y <= half_plane[3] }
        case covered
        when 0
            grid[y][x] = '.'
        when 1
            grid[y][x] = '+'
        when 2
            grid[y][x] = '#'
        when 3
            grid[y][x] = '*'
        end
    end
end


puts grid

# pp bots.map { |bot| bot[1] + bot[0][0] + bot[0][1] }
# pp bots.map { |bot| bot[1] - bot[0][0] + bot[0][1] }
# pp bots.map { |bot| bot[1] - bot[0][0] - bot[0][1] }
# pp bots.map { |bot| bot[1] + bot[0][0] - bot[0][1] }
# 20.times do |y|
#     20.times do |x|
#         covered = bots.count { |bot| x - y <= bot[1] + bot[0][0] - bot[0][1] }
#         case covered
#         when 0
#             grid[y][x] = '.'
#         when 1
#             grid[y][x] = '+'
#         when 2
#             grid[y][x] = '#'
#         end
#     end
# end


# puts grid
