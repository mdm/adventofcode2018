require 'pp'
require 'lazy_priority_queue'

MAX_X = 100000
ITEMS = ['T', 'C', 'N']

def erosion_level(x, y, depth, target, memo)
    return memo[y * MAX_X + x] unless memo[y * MAX_X + x].nil?

    if (x == 0 && y == 0) || (x == target[0] && y == target[1])
        idx = 0
    elsif x == 0
        idx = y * 48271
    elsif y == 0
        idx = x * 16807
    else
        idx = erosion_level(x - 1, y, depth, target, memo) * erosion_level(x, y - 1, depth, target, memo)
    end

    memo[y * MAX_X + x] = (idx + depth) % 20183
    memo[y * MAX_X + x]
end

depth = gets.split.last.to_i
target = gets.split.last.split(',').map { |coord| coord.to_i }

pp [depth, target]


memo = {}
path = {}
distances = {}
distances[0] = 0

pq = MinPriorityQueue.new
pq.push([[0, 0], 'T'], 0)

until pq.empty?
    # pp pq.size
    current = pq.pop

    pos, equipped = current
    distance = distances[pos[1] * MAX_X * 3 + pos[0] * 3 + ITEMS.index(equipped)]

    if pos[0] == target[0] && pos[1] == target[1]
        puts distance 

        # until path[pos[1] * MAX_X * 3 + pos[0] * 3 + ITEMS.index(equipped)].nil?
        #     pp pos, equipped
        #     new_equipped = ITEMS[path[pos[1] * MAX_X * 3 + pos[0] * 3 + ITEMS.index(equipped)] % 3]
        #     x = path[pos[1] * MAX_X * 3 + pos[0] * 3 + ITEMS.index(equipped)] / 3 % MAX_X
        #     y = path[pos[1] * MAX_X * 3 + pos[0] * 3 + ITEMS.index(equipped)] / 3 / MAX_X
        #     pos = [x, y]
        #     equipped = new_equipped
        # end

        break
    end

    steps = [[1, 0], [0, 1], [-1, 0], [0, -1]]
    steps.each do |step|
        new_pos = [pos[0] + step[0], pos[1] + step[1]]
        next if new_pos[0] < 0 || new_pos[1] < 0

        ITEMS.each do |item|
            next if new_pos[0] == target[0] && new_pos[1] == target[1] && item != 'T'
            next if item == 'N' && erosion_level(new_pos[0], new_pos[1], depth, target, memo) % 3 == 0
            next if item == 'T' && erosion_level(new_pos[0], new_pos[1], depth, target, memo) % 3 == 1
            next if item == 'C' && erosion_level(new_pos[0], new_pos[1], depth, target, memo) % 3 == 2

            new_distance = item == equipped ? distance + 1 : distance + 8

            if distances[new_pos[1] * MAX_X * 3 + new_pos[0] * 3 + ITEMS.index(item)].nil? || new_distance < distances[new_pos[1] * MAX_X * 3 + new_pos[0] * 3 + ITEMS.index(item)]
                distances[new_pos[1] * MAX_X * 3 + new_pos[0] * 3 + ITEMS.index(item)] = new_distance
                path[new_pos[1] * MAX_X * 3 + new_pos[0] * 3 + ITEMS.index(item)] = pos[1] * MAX_X * 3 + pos[0] * 3 + ITEMS.index(equipped)
                begin
                    pq.decrease_key([new_pos, item], new_distance)
                rescue
                    pq.push([new_pos, item], new_distance)
                end
            end
        end
    end
end
