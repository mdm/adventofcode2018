require 'pp'

stars = []
while line = gets
    groups = /position=<(.+),(.+)> velocity=<(.+),(.+)>/.match(line)
    stars << [groups[1].to_i, groups[2].to_i, groups[3].to_i, groups[4].to_i]
end

def width(stars)
    xs = stars.map { |star| star[0] }
    (xs.max - xs.min).abs + 1
end

def height(stars)
    ys = stars.map { |star| star[1] }
    (ys.max - ys.min).abs + 1
end

def update(stars)
    stars.map { |star| [star[0] + star[2], star[1] + star[3], star[2], star[3]] }
end

def display(stars)
    xs = stars.map { |star| star[0] }
    ys = stars.map { |star| star[1] }

    grid = []
    # puts width(stars), height(stars)
    height(stars).times do
        row = ['.'] * width(stars)
        grid << row
    end

    stars.each do |star|
        x = star[0] - xs.min
        y = star[1] - ys.min
        # pp [width(stars), height(stars), x, y]
        grid[y][x] = '#'
    end

    puts grid.map { |row| row.join }
end

cycles = 0
min = current = height(stars)
until current == 10
    stars = update(stars)
    current = height(stars)
    cycles += 1
    if current < min
        min = current
        pp [cycles, min]
    end
end

display(stars)
