require 'pp'

raw_grid = []
width = 0
while raw_line = gets
    width = raw_line.size if raw_line.size > width
    raw_grid << raw_line
end

carts = []
grid = raw_grid.map.with_index do |raw_line, y|
    raw_line.chars.map.with_index do |char, x|
        orientation = 'v^<>'.index(char)
        if orientation.nil?
            char
        else
            carts << [x, y, char, 0]
            if orientation < 2
                '|'
            else
                '-'
            end
        end
    end
end

ticks = 0
collision = false
loop do
    # pp [ticks, carts]
    carts = carts.sort_by do |cart|
        cart[1] * width + cart[0]
    end
    
    carts.map! do |cart|
        x, y, orientation, state = cart
        case grid[y][x]
        when '|'
            case orientation
            when 'v'
                x, y, orientation, state = [x, y + 1, 'v', state]
            when '^'
                x, y, orientation, state = [x, y - 1, '^', state]
            else
                puts 'ILLEGAL ORIENTATION'
            end
        when '-'
            case orientation
            when '<'
                x, y, orientation, state = [x - 1, y, '<', state]
            when '>'
                x, y, orientation, state = [x + 1, y, '>', state]
            else
                puts 'ILLEGAL ORIENTATION'
            end
        when '/'
            case orientation
            when 'v'
                x, y, orientation, state = [x - 1, y, '<', state]
            when '^'
                x, y, orientation, state = [x + 1, y, '>', state]
            when '<'
                x, y, orientation, state = [x, y + 1, 'v', state]
            when '>'
                x, y, orientation, state = [x, y - 1, '^', state]
            else
                puts 'ILLEGAL ORIENTATION'
            end
        when '\\'
            case orientation
            when 'v'
                x, y, orientation, state = [x + 1, y, '>', state]
            when '^'
                x, y, orientation, state = [x - 1, y, '<', state]
            when '<'
                x, y, orientation, state = [x, y - 1, '^', state]
            when '>'
                x, y, orientation, state = [x, y + 1, 'v', state]
            else
                puts 'ILLEGAL ORIENTATION'
            end
        when '+'
            case state % 3
            when 0
                # turn left
                case orientation
                when 'v'
                    x, y, orientation, state = [x + 1, y, '>', state + 1]
                when '^'
                    x, y, orientation, state = [x - 1, y, '<', state + 1]
                when '<'
                    x, y, orientation, state = [x, y + 1, 'v', state + 1]
                when '>'
                    x, y, orientation, state = [x, y - 1, '^', state + 1]
                else
                    puts 'ILLEGAL ORIENTATION'
                end
            when 1
                # go straight
                case orientation
                when 'v'
                    x, y, orientation, state = [x, y + 1, 'v', state + 1]
                when '^'
                    x, y, orientation, state = [x, y - 1, '^', state + 1]
                when '<'
                    x, y, orientation, state = [x - 1, y, '<', state + 1]
                when '>'
                    x, y, orientation, state = [x + 1, y, '>', state + 1]
                else
                    puts 'ILLEGAL ORIENTATION'
                end
            when 2
                # turn right
                case orientation
                when 'v'
                    x, y, orientation, state = [x - 1, y, '<', state + 1]
                when '^'
                    x, y, orientation, state = [x + 1, y, '>', state + 1]
                when '<'
                    x, y, orientation, state = [x, y - 1, '^', state + 1]
                when '>'
                    x, y, orientation, state = [x, y + 1, 'v', state + 1]
                else
                    puts 'ILLEGAL ORIENTATION'
                end
            else
                puts 'ILLEGAL STATE'
            end
        end

        collision = carts.count do |other_cart|
            other_cart[1] * width + other_cart[0] == y * width + x
        end > 0

        if collision
            # pp [y * width + x, carts.map { |other_cart| other_cart[1] * width + other_cart[0] }]
            pp [x, y]
            break
        end

        [x, y, orientation, state]
    end

    ticks += 1
    break if collision
end

pp [ticks, carts]
