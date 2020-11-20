require 'pp'

grid = []
while row = gets
    grid << row.chomp
end
pp grid

adjacent = [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]]
steps = 0
loop do
    next_grid = []
    grid.each_with_index do |row, y|
        next_row = ''
        row.chars.each_with_index do |acre, x|
            case acre
            when '.' # open
                trees = adjacent.count do |adjacent_acre|
                    adjacent_x, adjacent_y = adjacent_acre
                    on_grid = y + adjacent_y >= 0 && y + adjacent_y < grid.size && x + adjacent_x >= 0 && x + adjacent_x < grid[0].size
                    on_grid && grid[y + adjacent_y][x + adjacent_x] == '|'
                end
                if trees >= 3
                    next_row += '|'
                else
                    next_row += '.'
                end
            when '|' # trees
                lumberyards = adjacent.count do |adjacent_acre|
                    adjacent_x, adjacent_y = adjacent_acre
                    on_grid = y + adjacent_y >= 0 && y + adjacent_y < grid.size && x + adjacent_x >= 0 && x + adjacent_x < grid[0].size
                    on_grid && grid[y + adjacent_y][x + adjacent_x] == '#'
                end
                if lumberyards >= 3
                    next_row += '#'
                else
                    next_row += '|'
                end
            when '#' # lumberyard
                lumberyards = adjacent.count do |adjacent_acre|
                    adjacent_x, adjacent_y = adjacent_acre
                    on_grid = y + adjacent_y >= 0 && y + adjacent_y < grid.size && x + adjacent_x >= 0 && x + adjacent_x < grid[0].size
                    on_grid && grid[y + adjacent_y][x + adjacent_x] == '#'
                end
                trees = adjacent.count do |adjacent_acre|
                    adjacent_x, adjacent_y = adjacent_acre
                    on_grid = y + adjacent_y >= 0 && y + adjacent_y < grid.size && x + adjacent_x >= 0 && x + adjacent_x < grid[0].size
                    on_grid && grid[y + adjacent_y][x + adjacent_x] == '|'
                end
                if lumberyards == 0 || trees == 0
                    next_row += '.'
                else
                    next_row += '#'
                end
            end
        end
        next_grid << next_row
    end

    grid = next_grid
    steps += 1
    pp [steps, grid] if steps % 10 == 0
    break if steps == 1000
end

trees = 0
lumberyards = 0
grid.each_with_index do |row|
    row.chars.each_with_index do |acre|
        trees += 1 if acre == '|'
        lumberyards += 1 if acre == '#'
    end
end

pp [trees, lumberyards, trees * lumberyards]
