original = gets.chomp

min = original.size
min_unit = nil
('a'..'z').each do |unit_type|
    polymer = original.chars.reject do |unit|
        unit.downcase == unit_type
    end.join
    reacting = true
    while reacting
        reacting = false
        destroy = false
        tmp = polymer.chars.map.with_index do |unit, i|
            if destroy
                destroy = false
                # puts unit
                ''
            else
                if !polymer[i + 1].nil? && unit != polymer[i + 1] && unit.downcase == polymer[i + 1].downcase
                    # puts unit + polymer[i + 1]
                    reacting = true
                    destroy = true
                    # puts unit
                    ''
                else
                    unit
                end
            end
        end
        polymer = tmp.join
    end
    puts unit_type, polymer.size
    if polymer.size < min
        min_unit = unit_type
        min = polymer.size
    end
end

puts min_unit, min
