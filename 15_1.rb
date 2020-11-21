require 'pp'
require 'set'

class Unit
    attr_accessor :team, :x, :y, :hitpoints
end

cave = []
units = []
y = 0
while input_row = gets
    cave_row = []
    input_row.chomp.chars.each_with_index do |tile, x|
        if tile == 'G'
            unit = Unit.new
            unit.team = :goblins
            unit.x = x
            unit.y = y
            unit.hitpoints = 200
            units << unit
        end

        if tile == 'E'
            unit = Unit.new
            unit.team = :elves
            unit.x = x
            unit.y = y
            unit.hitpoints = 200
            units << unit
        end

        cave_row << tile
    end
    
    cave << cave_row
    y += 1
end

width = cave[0].size - 2
height = cave.size - 2

def enemy_tile(team)
    team == :goblins ? 'E' : 'G'
end

def enemy_adjacent(cave, team, y, x)
    return true if cave[y - 1][x] == enemy_tile(team)
    return true if cave[y][x - 1] == enemy_tile(team)
    return true if cave[y][x + 1] == enemy_tile(team)
    return true if cave[y + 1][x] == enemy_tile(team)
    false
end

def draw_cave(cave, unit = nil, target = nil)
    cave.each_with_index do |row, y|
        output = row.map.with_index do |tile, x|
            y == unit.y && x == unit.x ? "\033[32m#{tile}\033[0m" : tile
        end
        output = output.map.with_index do |tile, x|
            y == target[0] && x == target[1] ? "\033[31m#{tile}\033[0m" : tile
        end
        puts output.join('')
    end

    # sleep 1
end

rounds = 1
pp cave
loop do
    # break if rounds == 3
    puts "round #{rounds}"

    units = units.sort_by do |unit|
        unit.y * width + unit.x
    end

    victory = false
    units.each do |unit|
        next if unit.hitpoints <= 0

        targets = units.select do |candidate|
            candidate.team != unit.team && candidate.hitpoints > 0
        end
        
        if targets.size == 0
            victory = true
            break
        end

        # mark in range
        targets.each do |target|
            cave[target.y - 1][target.x] = '?' if cave[target.y - 1][target.x] == '.'
            cave[target.y][target.x - 1] = '?' if cave[target.y][target.x - 1] == '.'
            cave[target.y][target.x + 1] = '?' if cave[target.y][target.x + 1] == '.'
            cave[target.y + 1][target.x] = '?' if cave[target.y + 1][target.x] == '.'
        end

        # choose move
        chosen = nil
        chosen = [unit.y, unit.x, nil, 0] if enemy_adjacent(cave, unit.team, unit.y, unit.x)
        if unit.y == 11 && unit.x == 19 && unit.team == :elves
            puts 'CHECK'
            pp unit, chosen, enemy_adjacent(cave, unit.team, unit.y, unit.x)
        end

        visited = Set.new
        queue = [[unit.y, unit.x, nil, 0]]
        visited.add([unit.y, unit.x])
        until !chosen.nil? || queue.empty?
            current = queue.shift
            # if cave[current[0]][current[1]] == '?' && enemy_adjacent(cave, unit.team, current[0], current[1])
            if cave[current[0]][current[1]] == '?'
                chosen = current
            end

            if '.?'.include?(cave[current[0] - 1][current[1]]) && !visited.include?([current[0] - 1, current[1]])
                if current[2].nil?
                    queue << [current[0] - 1, current[1], :north, current[3] + 1]
                else
                    queue << [current[0] - 1, current[1], current[2], current[3] + 1]
                end
                visited.add([current[0] - 1, current[1]])
            end

            if '.?'.include?(cave[current[0]][current[1] - 1]) && !visited.include?([current[0], current[1] - 1])
                if current[2].nil?
                    queue << [current[0], current[1] - 1, :west, current[3] + 1]
                else
                    queue << [current[0], current[1] - 1, current[2], current[3] + 1]
                end
                visited.add([current[0], current[1] - 1])
            end

            if '.?'.include?(cave[current[0]][current[1] + 1]) && !visited.include?([current[0], current[1] + 1])
                if current[2].nil?
                    queue << [current[0], current[1] + 1, :east, current[3] + 1]
                else
                    queue << [current[0], current[1] + 1, current[2], current[3] + 1]
                end
                visited.add([current[0], current[1] + 1])
            end

            if '.?'.include?(cave[current[0] + 1][current[1]]) && !visited.include?([current[0] + 1, current[1]])
                if current[2].nil?
                    queue << [current[0] + 1, current[1], :south, current[3] + 1]
                else
                    queue << [current[0] + 1, current[1], current[2], current[3] + 1]
                end
                visited.add([current[0] + 1, current[1]])
            end
        end
        pp unit, chosen
        # queue = queue.select do |candidate|
        #     cave[candidate[0]][candidate[1]] == '?' && !chosen.nil? && candidate[2] != chosen[2] && candidate[3] == chosen[3]
        # end
        # pp queue

        # move
        unless chosen.nil? || chosen[2].nil?
            # puts "\033[2J"
            puts "unit moves #{chosen[2].to_s}"
            draw_cave(cave, unit, [chosen[0], chosen[1]])

            cave[unit.y][unit.x] = '.'

            unit.y -= 1 if chosen[2] == :north
            unit.x -= 1 if chosen[2] == :west
            unit.x += 1 if chosen[2] == :east
            unit.y += 1 if chosen[2] == :south

            cave[unit.y][unit.x] = 'G' if unit.team == :goblins
            cave[unit.y][unit.x] = 'E' if unit.team == :elves

            # puts "\033[2J"
            puts "unit moved"
            draw_cave(cave, unit, [chosen[0], chosen[1]])
        end
        
        # unmark in range
        cave.map! do |row|
            row.map! do |tile|
                tile == '?' ? '.' : tile
            end
        end

        # chose attack target
        targets = units.select do |candidate|
            candidate.team != unit.team && candidate.hitpoints > 0
        end
        
        targets = targets.select do |candidate|
            (candidate.x - unit.x).abs + (candidate.y - unit.y).abs == 1
        end

        targets = targets.sort_by do |candidate|
            candidate.hitpoints * width * height + candidate.y * width + candidate.x
        end

        # attack
        unless targets.empty?
            target = targets.shift

            # puts "\033[2J"
            puts "unit attacks"
            draw_cave(cave, unit, [target.y, target.x])

            target.hitpoints -= 3
            if target.hitpoints <= 0
                cave[target.y][target.x] = '.'
            end
        end
    end

    if victory
        units = units.sort_by do |unit|
            unit.y * width + unit.x
        end
        pp units

        hitpoints = units.map do |unit|
            [unit.hitpoints, 0].max
        end
        total = hitpoints.sum
        puts rounds - 1, total, (rounds - 1) * total
        break
    end

    # cave.each do |row|
    #     pp row.join('')
    # end
    # units = units.sort_by do |unit|
    #     unit.y * width + unit.x
    # end
    # pp units

    rounds += 1
end