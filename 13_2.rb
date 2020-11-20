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
    
    new_carts = carts.map do |cart|
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

        [x, y, orientation, state]
    end

    # pp carts, new_carts
    collisions = new_carts.map.with_index do |new_cart, new_i|
        collision = nil
        new_carts.each_with_index do |old_cart, old_i|
            # pp [ticks, old_i, new_i, new_i < old_i, old_cart[1] * width + old_cart[0] == new_cart[1] * width + new_cart[0]]
            if old_i < new_i && new_carts[old_i][1] * width + new_carts[old_i][0] == new_cart[1] * width + new_cart[0]
                collision = [old_i, new_i]
                break
            end
            if new_i < old_i && old_cart[1] * width + old_cart[0] == new_cart[1] * width + new_cart[0]
                collision = [old_i, new_i]
                break
            end
        end
        collision
    end.reject { |collision| collision.nil? }.flatten.uniq
    pp [ticks, collisions, collisions.map { |collision| new_carts[collision] }] if collisions.size > 0

    # pp ['BEFORE', carts.size, carts, collisions] if collisions.size > 0
    carts = new_carts.reject.with_index { |new_cart, i| collisions.include?(i) }
    # pp ['AFTER', carts.size, carts] if collisions.size > 0


    # break if carts.size < 2


    ticks += 1
    break if ticks >= 6689
end

pp [ticks, carts]
