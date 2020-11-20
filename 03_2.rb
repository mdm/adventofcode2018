require 'set'
require 'pp'

claims = []
max_x = 0
max_y = 0
while raw = gets
    parts = raw.split
    claim = {}
    claim[:id] = parts[0].chars.drop(1).join.to_i
    claim[:x], claim[:y] = parts[2].chars.reverse.drop(1).reverse.join.split(',').map { |s| s.to_i}
    claim[:w], claim[:h] = parts[3].split('x').map { |s| s.to_i}
    claims << claim
    max_x = claim[:x] + claim[:w] if claim[:x] + claim[:w] > max_x
    max_y = claim[:y] + claim[:h] if claim[:y] + claim[:h] > max_y
end

fabric = []
max_y.times do
    row = []
    max_x.times do
        row << 0
    end
    fabric << row
end

claims.each do |claim|
    claim[:h].times do |y|
        claim[:w].times do |x|
            fabric[claim[:y] + y][claim[:x] + x] += 1
        end
    end
end

claims.each do |claim|
    overlaps = false
    claim[:h].times do |y|
        claim[:w].times do |x|
            overlaps = true if fabric[claim[:y] + y][claim[:x] + x] > 1
        end
    end

    puts claim[:id] unless overlaps
end
