require 'pp'

def manhattan(coords_a, coords_b)
    (coords_a[0] - coords_b[0]).abs + (coords_a[1] - coords_b[1]).abs
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
