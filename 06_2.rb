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


region = 0
(max_y + 1).times do |y|
    (max_x + 1).times do |x|
        sum = 0
        coords.each do |coord|
            sum += (coord[0] - x).abs + (coord[1] - y).abs
        end

        # puts sum if x == 0 || y == 0 || x == max_x || y == max_y

        region +=1 if sum < 10000
    end
end

puts region