require 'pp'
require 'set'
require 'chunky_png'

def save_png(grid, id)
    png = ChunkyPNG::Image.new(grid[0].size, grid.size, ChunkyPNG::Color::TRANSPARENT)
    grid.each_with_index do |row, y|
        row.chars.each_with_index do |cell, x|
            case cell
            when '+'
                png[x, y] = ChunkyPNG::Color.rgba(0, 255, 0, 255)
            when '#'
                png[x, y] = ChunkyPNG::Color.rgba(255, 0, 0, 255)
            when '~'
                png[x, y] = ChunkyPNG::Color.rgba(0, 0, 255, 255)
            when '|'
                png[x, y] = ChunkyPNG::Color.rgba(0, 255, 255, 255)
            else
                png[x, y] = ChunkyPNG::Color.rgba(0, 0, 0, 255)
            end
        end
    end
    png.save("17_1_#{id.to_s}.png", :interlace => true)
end

clay_coords = Set.new
while vein = gets
    fixed, variable = vein.split(', ')
    fixed_axis, fixed_value = fixed.split('=')
    fixed_value = fixed_value.to_i
    variable = variable.split('=').last
    variable_start, variable_end = variable.split('..').map { |s| s.to_i }
    if fixed_axis == 'x'
        (variable_start..variable_end).each do |variable_value|
            clay_coords.add([fixed_value, variable_value])
        end
    else
        (variable_start..variable_end).each do |variable_value|
            clay_coords.add([variable_value, fixed_value])
        end
    end
end

x_min = [500, clay_coords.to_a.map { |coord| coord[0] }.min - 1].min
x_max = [500, clay_coords.to_a.map { |coord| coord[0] }.max + 1].max
y_min = clay_coords.to_a.map { |coord| coord[1] }.min
y_max = clay_coords.to_a.map { |coord| coord[1] }.max
pp [x_min, x_max, y_min, y_max]

grid = []
(0..y_max).each do |y|
    row = ''
    (0..(x_max - x_min)).each do |x|
        if clay_coords.include?([x_min + x, y])
            row += '#'
        else
            row += '.'
        end
    end
    grid << row
end

grid[0][500 - x_min] = '+'
save_png(grid, 'initial')
# pp grid

steps = 0
# loop do
    flowing = false
    active_water = []
    grid.each_with_index do |row, y|
        row.chars.each_with_index do |cell, x|
            active_water << [x, y] if grid[y][x] == '|' || grid[y][x] == '+'
        end
    end
loop do
    active_water.each do |water|
        x, y = water
        next if y == y_max

        if grid[y + 1][x] == '.'
            # can move downward
            # pp [water, 'down']
            flowing = true
            grid[y + 1][x] = '|'
        else
            next unless grid[y + 1][x] == '#' || grid[y + 1][x] == '~'

            blocked = true
            # cannot move downward
            if x > 0 && grid[y][x - 1] == '.'
                # can move left
                # pp [water, 'left']
                blocked = false
                flowing = true
                grid[y][x - 1] = '|'
            end

            if x < x_max && grid[y][x + 1] == '.'
                # can move right
                # pp [water, 'right']
                blocked = false
                flowing = true
                grid[y][x + 1] = '|'
            end

            if blocked
                # solidify
                # pp [water, 'solidify']
                left = x - 1
                until grid[y][left] == '.' || grid[y][left] == '#'
                    left -= 1
                end
                right = x + 1
                until grid[y][right] == '.' || grid[y][right] == '#'
                    right += 1
                end

                if grid[y][left] == '#' && grid[y][right] == '#'
                    flowing = true
                    grid[y][x] = '~' 
                end
            end
        end
    end

    steps += 1
    puts steps 
    save_png(grid, steps) if steps % 1000 == 0
    # break if steps == 20
    break unless flowing
end

save_png(grid, 'final')

count = 0
safe = 0
grid.each_with_index do |row, y|
    row.chars.each_with_index do |cell, x|
        count += 1 if grid[y][x] == '|' || grid[y][x] == '~' || grid[y][x] == '+'
        safe += 1 if grid[y][x] == '~'
    end
end
puts count - y_min, safe
