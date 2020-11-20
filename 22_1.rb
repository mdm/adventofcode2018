require 'pp'

depth = gets.split.last.to_i
target = gets.split.last.split(',').map { |coord| coord.to_i }
width, height = target.map { |coord| coord + 1 }

pp [depth, target]
grid = []
levels = []
height.times do
    grid << '?' * width
    levels << [0] * width
end

risk = 0
height.times do |y|
    width.times do |x|
        if (x == 0 && y == 0) || (x == target[0] && y == target[1])
            idx = 0
        elsif x == 0
            idx = y * 48271
        elsif y == 0
            idx = x * 16807
        else
            idx = levels[y][x - 1] * levels[y - 1][x]
        end

        levels[y][x] = (idx + depth) % 20183

        risk += levels[y][x] % 3
        case levels[y][x] % 3
        when 0
            grid[y][x] = '.'
        when 1
            grid[y][x] = '='
        when 2
            grid[y][x] = '|'
        end
    end
end

grid[target[1]][target[0]] = '.'
puts grid, risk
