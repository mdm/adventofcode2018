require 'pp'
require 'set'

grid = []
hitpoints = []
while row = gets
    grid << row
    hitpoints << ([200] * row.size)
end

width = grid[0].size - 2
height = grid.size - 2

def mark_targets(grid, unit_x, unit_y)
    width = grid[0].size - 2
    height = grid.size - 2

    enemy = grid[unit_y][unit_x] == 'E' ? 'G' : 'E'
    victory = true
    (1..height).each do |target_y|
        (1..width).each do |target_x|
            next unless grid[target_y][target_x] == enemy
            victory = false

            return [false, victory] if target_x == unit_x && target_y - 1 == unit_y
            return [false, victory] if target_x - 1 == unit_x && target_y == unit_y
            return [false, victory] if target_x + 1 == unit_x && target_y == unit_y
            return [false, victory] if target_x == unit_x && target_y + 1 == unit_y

            grid[target_y - 1][target_x] = '?' if grid[target_y - 1][target_x] == '.'
            grid[target_y][target_x - 1] = '?' if grid[target_y][target_x - 1] == '.'
            grid[target_y][target_x + 1] = '?' if grid[target_y][target_x + 1] == '.'
            grid[target_y + 1][target_x] = '?' if grid[target_y + 1][target_x] == '.'
        end
    end

    [true, victory]
end

def unmark_targets(grid)
    width = grid[0].size - 2
    height = grid.size - 2

    (1..height).each do |target_y|
        (1..width).each do |target_x|
            grid[target_y][target_x] = '.' if grid[target_y][target_x] == '?'
        end
    end
end

def to_id(grid, x, y)
    width = grid[0].size
    y * width + x
end

def to_coords(grid, id)
    width = grid[0].size
    [id % width, id / width]
end

rounds = 0
pp grid
loop do
    pp ['round', rounds]
    moved = Set.new
    victory = false
    (1..height).each do |unit_y|
        (1..width).each do |unit_x|
            next unless 'EG'.include?(grid[unit_y][unit_x])

            unit = to_id(grid, unit_x, unit_y)
            next if moved.include?(unit)

            move, victory = mark_targets(grid, unit_x, unit_y)
            # pp ['*', unit_x, unit_y, move]
            # pp grid
            moved_x = unit_x
            moved_y = unit_y
            if move
                # move
                # pp ['moving', [unit_x, unit_y]]
                queue = [unit]
                previous = {}
                seen = Set.new
                candidates = []
                loop do
                    # pp queue.map { |item| to_coords(grid, item) }
                    if queue.empty?
                        puts '$$$'
                        candidates = candidates.take_while do |candidate|
                            tile_0, distance_0 = candidates[0]
                            tile, distance = candidate
                            distance == distance_0
                        end

                        break if candidates.empty?

                        candidates = candidates.map do |candidate|
                            tile, distance = candidate
                            tile
                        end

                        # puts '***'
                        tile = candidates.min
                        tile_x, tile_y = to_coords(grid, tile)
                        grid[tile_y][tile_x] = grid[unit_y][unit_x]
                        grid[unit_y][unit_x] = '.'
                        hitpoints[tile_y][tile_x] = hitpoints[unit_y][unit_x]
                        moved_x = tile_x
                        moved_y = tile_y
                        moved.add(tile)
                        break
                    end

                    tile = queue.shift
                    tile_x, tile_y = to_coords(grid, tile)
                    # pp [tile_x, tile_y]
                    if grid[tile_y][tile_x] == '?'
                        distance = 1
                        current = tile
                        loop do
                            ancestor = previous[current]
                            # pp to_coords(grid, ancestor)
                            break if ancestor == unit
                            current = ancestor
                            distance += 1
                        end

                        candidates << [tile, distance] unless candidates.include?([tile, distance])
                        pp ['!', candidates.size, queue.size]
                    end
                    pp ['?', tile]
                    seen.add(tile)

                    step = to_id(grid, tile_x, tile_y - 1)
                    if (grid[tile_y - 1][tile_x] == '.' || grid[tile_y - 1][tile_x] == '?') && !seen.include?(step)
                        queue << step unless queue.include?(step)
                        previous[step] = tile if previous[step].nil? || tile < previous[step]
                    end
                    step = to_id(grid, tile_x - 1, tile_y)
                    if (grid[tile_y][tile_x - 1] == '.' || grid[tile_y][tile_x - 1] == '?') && !seen.include?(step)
                        queue << step unless queue.include?(step)
                        previous[step] = tile if previous[step].nil? || tile < previous[step]
                    end
                    step = to_id(grid, tile_x + 1, tile_y)
                    if (grid[tile_y][tile_x + 1] == '.' || grid[tile_y][tile_x + 1] == '?') && !seen.include?(step)
                        queue << step unless queue.include?(step)
                        previous[step] = tile if previous[step].nil? || tile < previous[step]
                    end
                    step = to_id(grid, tile_x, tile_y + 1)
                    if (grid[tile_y + 1][tile_x] == '.' || grid[tile_y + 1][tile_x] == '?') && !seen.include?(step)
                        queue << step unless queue.include?(step)
                        previous[step] = tile if previous[step].nil? || tile < previous[step]
                    end
                    pp ['!', candidates.size, queue.size, queue[0], seen.include?(queue[0])]
                end
            end
            unmark_targets(grid)
            # pp grid

            # attack
            # pp ['attcking', [unit_x, unit_y]]
            enemy = grid[moved_y][moved_x] == 'E' ? 'G' : 'E'
            targets = []
            targets << [moved_x, moved_y - 1, 0] if grid[moved_y - 1][moved_x] == enemy
            targets << [moved_x - 1, moved_y, 1] if grid[moved_y][moved_x - 1] == enemy
            targets << [moved_x + 1, moved_y, 2] if grid[moved_y][moved_x + 1] == enemy
            targets << [moved_x, moved_y + 1, 3] if grid[moved_y + 1][moved_x] == enemy
            targets = targets.sort_by do |target|
                target_x, target_y, priority = target
                hitpoints[target_y][target_x] * 4 + priority
            end

            # puts '******'
            # pp grid, [moved_x, moved_y, hitpoints[moved_y][moved_x], targets]
            # puts '******'
            unless targets.empty?
                target_x, target_y, _ = targets.shift
                hitpoints[target_y][target_x] -= 3
                grid[target_y][target_x] = '.' if hitpoints[target_y][target_x] <= 0
            end
        end
    end

    pp grid
    # elves = 0
    # goblins = 0
    remaining_hitpoints = 0
    (1..height).each do |unit_y|
        (1..width).each do |unit_x|
            next unless 'EG'.include?(grid[unit_y][unit_x])
            pp [unit_x, unit_y, hitpoints[unit_y][unit_x]]
            # elves += 1 if grid[unit_y][unit_x] == 'E'
            # goblins += 1 if grid[unit_y][unit_x] == 'G'
            remaining_hitpoints += hitpoints[unit_y][unit_x]
        end
    end

    # if elves == 0 || goblins == 0
    if victory
        pp [rounds, remaining_hitpoints, rounds * remaining_hitpoints]
        break
    end

    rounds += 1
end