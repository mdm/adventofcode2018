require 'pp'

fixed_points = []
while line = gets
    fixed_points << line.split(',').map(&:to_i)
end

constellations = []
fixed_points.each do |fixed_point|
    in_constellation = []
    constellations.each_with_index do |constellation, c|
        constellation.each do |constellation_point|
            distance = fixed_point.zip(constellation_point).map { |a, b| (a - b).abs }.sum
            if distance <= 3
                in_constellation << c
                break
            end
        end
    end

    if in_constellation.size == 0
        constellations << [fixed_point]
    else
        connected = constellations.select.each_with_index { |constellation, c| in_constellation.include?(c) }
        constellations = constellations.reject.each_with_index { |constellation, c| in_constellation.include?(c) }

        connected << [fixed_point]
        constellations << connected.reduce(:concat)
    end
end

pp constellations.size
