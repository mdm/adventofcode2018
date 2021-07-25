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


# grid = []
# 20.times { grid << ('.' * 20) }

# bots = []
# bots << [[7, 7], 5]
# bots << [[11, 10], 8]
# 20.times do |y|
#     20.times do |x|
#         covered = bots.count { |bot| quadrant_pp([x, y], bot[0]) == bot[1] }
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
# puts


grid = []
20.times { grid << ('.' * 20) }

bots = []
bots << [[7, 7], 5]
bots << [[11, 10], 8]
20.times do |y|
    20.times do |x|
        covered = bots.count { |bot| -x - y == bot[1] - bot[0][0] - bot[0][1] }
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
