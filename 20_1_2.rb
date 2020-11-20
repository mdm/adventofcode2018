require 'pp'
require 'set'

directions = gets.chomp.chars
directions.shift
directions.pop

def explore(x, y, directions, distances, starts = [], ends = [])
    until directions.first.nil?
        case directions.shift
        when 'N'
            distance = distances[[x, y]]
            y -= 1
            distances[[x, y]] = distance + 1 if distances[[x, y]].nil? || distances[[x, y]] > distance + 1
        when 'S'
            distance = distances[[x, y]]
            y += 1
            distances[[x, y]] = distance + 1 if distances[[x, y]].nil? || distances[[x, y]] > distance + 1
        when 'E'
            distance = distances[[x, y]]
            x += 1
            distances[[x, y]] = distance + 1 if distances[[x, y]].nil? || distances[[x, y]] > distance + 1
        when 'W'
            distance = distances[[x, y]]
            x -= 1
            distances[[x, y]] = distance + 1 if distances[[x, y]].nil? || distances[[x, y]] > distance + 1
        when '('
            starts << [x, y]
            ends << []
        when '|'
            ends.last << [x, y]
            x, y = starts.last
        when ')'
            ends.last << [x, y]
            starts.pop
            ends.pop.each do |start|
                x, y = start
                distances = explore(x, y, directions, distances, starts, ends)
            end
            break
        else
            puts 'UNRECOGNIZED CHAR'
        end
    end

    distances
end

distances = {}
distances[[0, 0]] = 0
distances = explore(0, 0, directions, distances)
puts distances.values.max
puts distances.values.reject { |distance| distance < 1000 }.size
