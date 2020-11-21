require 'pp'
require 'set'

class Unit
    attr_accessor :team, :x, :y, :hitpoints
end

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

def battle(cave, units, power, elves_must_live)
    width = cave[0].size - 2
    height = cave.size - 2
    
    rounds = 1
    loop do
        # break if rounds == 2
        # puts "round #{rounds}"

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

            if chosen.nil?
                visited = Set.new
                queue = [[unit.y, unit.x, nil, 0]]
                visited.add([unit.y, unit.x])
                moves = []           
                until queue.empty?
                    current = queue.shift
                    if cave[current[0]][current[1]] == '?'
                        moves << current
                    end

                    if '.?'.include?(cave[current[0] - 1][current[1]]) && !visited.include?([current[0] - 1, current[1]])
                        if current[2].nil?
                            queue << [current[0] - 1, current[1], 0, current[3] + 1]
                        else
                            queue << [current[0] - 1, current[1], current[2], current[3] + 1]
                        end
                        visited.add([current[0] - 1, current[1]])
                    end

                    if '.?'.include?(cave[current[0]][current[1] - 1]) && !visited.include?([current[0], current[1] - 1])
                        if current[2].nil?
                            queue << [current[0], current[1] - 1, 1, current[3] + 1]
                        else
                            queue << [current[0], current[1] - 1, current[2], current[3] + 1]
                        end
                        visited.add([current[0], current[1] - 1])
                    end

                    if '.?'.include?(cave[current[0]][current[1] + 1]) && !visited.include?([current[0], current[1] + 1])
                        if current[2].nil?
                            queue << [current[0], current[1] + 1, 2, current[3] + 1]
                        else
                            queue << [current[0], current[1] + 1, current[2], current[3] + 1]
                        end
                        visited.add([current[0], current[1] + 1])
                    end

                    if '.?'.include?(cave[current[0] + 1][current[1]]) && !visited.include?([current[0] + 1, current[1]])
                        if current[2].nil?
                            queue << [current[0] + 1, current[1], 3, current[3] + 1]
                        else
                            queue << [current[0] + 1, current[1], current[2], current[3] + 1]
                        end
                        visited.add([current[0] + 1, current[1]])
                    end
                end

                moves = moves.sort_by do |move|
                    # [move[3], move[2]] # this was the final bug in part one - reading order of the target was not taken into account
                    [move[3], move[0] * width + move[1], move[2]]
                end

                chosen = moves[0] unless moves.empty?
            end
            # pp unit, chosen

            # move
            unless chosen.nil? || chosen[2].nil?
                # puts "\033[2J"
                # puts "unit moves #{chosen[2].to_s}"
                # draw_cave(cave, unit, [chosen[0], chosen[1]])

                cave[unit.y][unit.x] = '.'

                unit.y -= 1 if chosen[2] == 0
                unit.x -= 1 if chosen[2] == 1
                unit.x += 1 if chosen[2] == 2
                unit.y += 1 if chosen[2] == 3

                cave[unit.y][unit.x] = 'G' if unit.team == :goblins
                cave[unit.y][unit.x] = 'E' if unit.team == :elves

                # puts "\033[2J"
                # puts "unit moved"
                # draw_cave(cave, unit, [chosen[0], chosen[1]])
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
                # puts "unit attacks"
                # draw_cave(cave, unit, [target.y, target.x])

                target.hitpoints -= 3 if unit.team == :goblins
                target.hitpoints -= power if unit.team == :elves
                if target.hitpoints <= 0
                    cave[target.y][target.x] = '.'
                    return 0 if elves_must_live && target.team == :elves
                end
            end
        end

        if victory
            # units = units.sort_by do |unit|
            #     unit.y * width + unit.x
            # end
            # pp units

            hitpoints = units.map do |unit|
                [unit.hitpoints, 0].max
            end
            total = hitpoints.sum
            return (rounds - 1) * total
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

puts battle(cave.map { |tile| tile.dup }, units.map { |unit| unit.dup }, 3, false)
power = 4
loop do
    outcome = battle(cave.map { |tile| tile.dup }, units.map { |unit| unit.dup }, power, true)
    
    if outcome > 0
        puts outcome
        break
    end

    power += 1
end
