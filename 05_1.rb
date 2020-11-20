polymer = gets.chomp
puts polymer.size

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
    puts polymer.size
end
