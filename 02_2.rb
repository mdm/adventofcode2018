require 'set'
require 'pp'

ids = []
while id = gets
    ids << id
end

ids.each_with_index do |id_a, index_a|
    ids.each_with_index do |id_b, index_b|
        next if id_a >= id_b

        diffs = 0
        common = ''
        id_a.chars.each_with_index do |char, index|
            if id_b[index] == char
                common += char
            else
                diffs += 1
            end
        end

        puts id_a, id_b, common if diffs == 1
    end
end
