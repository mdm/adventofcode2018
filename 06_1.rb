require 'pp'
require 'set'

coords = []
max_x = 0
max_y = 0
while raw_coord = gets
    coord = raw_coord.split(',').map { |part| part.strip.to_i }
    coords << coord
    max_x = coord[0] if coord[0] > max_x
    max_y = coord[1] if coord[1] > max_y
end

def closest(x, y, coords)
    distances = coords.map do |coord|
        (coord[0] - x).abs + (coord[1] - y).abs
    end

    closest_index = nil
    distances.each_with_index do |distance, i|
        if distance == distances.min
            if closest_index.nil?
                closest_index = i
            else
                return nil
            end
        end
    end

    closest_index
end

infinites = Set.new

(max_x + 1).times do |x|
    candidate = closest(x, 0, coords)
    infinites.add(candidate) unless candidate.nil?
    candidate = closest(x, max_y, coords)
    infinites.add(candidate) unless candidate.nil?
end

(max_y + 1).times do |y|
    candidate = closest(0, y, coords)
    infinites.add(candidate) unless candidate.nil?
    candidate = closest(max_x, y, coords)
    infinites.add(candidate) unless candidate.nil?
end

sizes = [0] * coords.size
(max_y + 1).times do |y|
    (max_x + 1).times do |x|
        coord = closest(x, y, coords)
        unless coord.nil?
            sizes[coord] += 1 
        end
    end
end

finite_sizes = sizes.reject.with_index { |size, i| infinites.include?(i) }

puts finite_sizes.max
