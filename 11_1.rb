require 'pp'

serial_nr = 8979

grid = []
300.times do |y|
    row = []
    300.times do |x|
        rack_id = x + 1 + 10
        power = rack_id
        power *= y + 1
        power += serial_nr
        power *= rack_id
        power %= 1000
        power /= 100
        power -= 5
        row << power
    end
    grid << row
end

max = 0
argmax = nil
300.times do |y|
    300.times do |x|
        power = 0
        300.times do |size|
            next unless x + size < 300 && y + size < 300
            (size + 1).times do |i|
                power += grid[y + size][x + i]
                power += grid[y + i][x + size]
            end
            power -= grid[y + size][x + size]

            if power > max
                max = power
                argmax = [x + 1, y + 1, size + 1]
            end
        end
    end
end

pp max, argmax
