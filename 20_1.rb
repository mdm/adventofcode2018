require 'pp'
require 'set'

directions = gets.chomp.chars
directions.shift
directions.pop

pp directions.join

def extract_group(directions)
    count = 0
    current = 1
    until count == 0 && directions[current] == '|'
        count += 1 if directions[current] == '('
        count -= 1 if directions[current] == ')'
        current += 1
    end
    group_middle = current

    count = 0
    current = group_middle + 1
    until count == 0 && directions[current] == ')'
        count += 1 if directions[current] == '('
        count -= 1 if directions[current] == ')'
        current += 1
    end
    group_end = current

    [group_middle, group_end]
end

def explore(rooms, directions, x, y)
    until directions.first.nil? || directions.first == '('
        case directions.first
        when 'N'
            rooms[[x, y]][0] = true
            y -= 1
            rooms[[x, y]] = [false, false, false, false] if rooms[[x, y]].nil?
            rooms[[x, y]][1] = true
        when 'S'
            rooms[[x, y]][1] = true
            y += 1
            rooms[[x, y]] = [false, false, false, false] if rooms[[x, y]].nil?
            rooms[[x, y]][0] = true
        when 'E'
            rooms[[x, y]][2] = true
            x += 1
            rooms[[x, y]] = [false, false, false, false] if rooms[[x, y]].nil?
            rooms[[x, y]][3] = true
        when 'W'
            rooms[[x, y]][3] = true
            x -= 1
            rooms[[x, y]] = [false, false, false, false] if rooms[[x, y]].nil?
            rooms[[x, y]][2] = true
        else
            ['UNEXPECTED', directions.first]
        end
        directions.shift
    end

    if directions.first == '('
        group_middle, group_end = extract_group(directions)
        option_a = directions[1..(group_middle - 1)]
        option_b = directions[(group_middle + 1)..(group_end - 1)]
        directions.shift(group_end + 1)
        rooms, new_x, new_y = explore(rooms, option_a, x, y)
        rooms, _, _ = explore(rooms, directions, new_x, new_y)
        rooms, new_x, new_y = explore(rooms, option_b, x, y)
        rooms, _, _ = explore(rooms, directions, new_x, new_y)            
    end

    [rooms, x, y]
end

def draw_map(rooms, distances)
    x_coords = rooms.keys.map { |room| room[0] }
    x_min = x_coords.min
    x_max = x_coords.max
    y_coords = rooms.keys.map { |room| room[1] }
    y_min = y_coords.min
    y_max = y_coords.max

    grid = []
    ((y_max - y_min + 1) * 2 + 1).times do
        grid << '#' * ((x_max - x_min + 1) * 2 + 1)
    end

    (y_min..y_max).each do |y|
        (x_min..x_max).each do |x|
            next unless rooms.keys.include?([x, y])
            grid_x = (x - x_min) * 2 + 1
            grid_y = (y - y_min) * 2 + 1
            grid[grid_y][grid_x] = (distances[[x, y]] % 10).to_s
            grid[grid_y][grid_x] = 'X' if x == 0 && y == 0
            grid[grid_y][grid_x] = 'O' if x == -46 && y == -45
            north, south, east, west = rooms[[x, y]]
            grid[grid_y - 1][grid_x] = '-' if north
            grid[grid_y + 1][grid_x] = '-' if south
            grid[grid_y][grid_x + 1] = '|' if east
            grid[grid_y][grid_x - 1] = '|' if west
        end
    end

    puts grid
    pp [x_max - x_min + 1, y_max - y_min + 1]
    puts
end

def bfs(rooms, start)
    distances = {}
    distances[start] = 0
    visited = Set.new
    queue = [start]
    until queue.empty?
        room = queue.shift
        north, south, east, west = rooms[room]

        adjacent = [room[0], room[1] - 1]
        if north && !visited.include?(adjacent)
            queue << adjacent unless queue.include?(adjacent)
            unless distances[adjacent].nil?
                pp ['!!' , adjacent, distances[adjacent], distances[room] + 1]
            end
            distances[adjacent] = distances[room] + 1 if distances[adjacent].nil? # || distances[adjacent] > distances[room] + 1
        end

        adjacent = [room[0], room[1] + 1]
        if south && !visited.include?(adjacent)
            queue << adjacent unless queue.include?(adjacent)
            unless distances[adjacent].nil?
                pp ['!!' , adjacent, distances[adjacent], distances[room] + 1]
            end
            distances[adjacent] = distances[room] + 1 if distances[adjacent].nil? # || distances[adjacent] > distances[room] + 1
        end

        adjacent = [room[0] + 1, room[1]]
        if east && !visited.include?(adjacent)
            queue << adjacent unless queue.include?(adjacent)
            unless distances[adjacent].nil?
                pp ['!!' , adjacent, distances[adjacent], distances[room] + 1]
            end
            distances[adjacent] = distances[room] + 1 if distances[adjacent].nil? # || distances[adjacent] > distances[room] + 1
        end

        adjacent = [room[0] - 1, room[1]]
        if west && !visited.include?(adjacent)
            queue << adjacent unless queue.include?(adjacent)
            unless distances[adjacent].nil?
                pp ['!!' , adjacent, distances[adjacent], distances[room] + 1]
            end
            distances[adjacent] = distances[room] + 1 if distances[adjacent].nil? # || distances[adjacent] > distances[room] + 1
        end

        visited.add(room)
    end

    # max_value = distances.values.max
    # distances.each_pair do |key, value|
    #     return [key, value] if value == max_value
    # end
    distances
end

rooms = {}
rooms[[0, 0]] = [false, false, false, false]
rooms, _, _ = explore(rooms, directions, 0, 0)
distances = bfs(rooms, [0, 0])
pp [rooms.size, distances.size]
# pp rooms.keys.sort
pp [distances[[-46, -45]], distances[[-46, -44]]]
draw_map(rooms, distances)
puts distances.values.max
