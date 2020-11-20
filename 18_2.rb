require 'pp'

grid = []
while row = gets
    grid << row.chomp
end
pp grid

adjacent = [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]]
steps = 0
history = [grid]
loop_start = nil
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

    history.each_with_index do |past_grid, i|
        grid_with_index = past_grid.map.with_index { |row, i| [row, i] }
        looping = grid_with_index.all? do |row_with_index|
            row, y = row_with_index
            row == next_grid[y]
        end
        if looping
            loop_start = i
            break
        end
    end
    history << next_grid

    unless loop_start.nil?
        pp ['loop', loop_start, steps]
        break
    end
end

target = loop_start + (1000000000 - loop_start) % (steps - loop_start)
pp target

trees = 0
lumberyards = 0
history[target].each_with_index do |row|
    row.chars.each_with_index do |acre|
        trees += 1 if acre == '|'
        lumberyards += 1 if acre == '#'
    end
end

pp [trees, lumberyards, trees * lumberyards]
