require 'set'

changes = []
while i = gets
    changes << i.to_i
end

freq = 0
seen = [0].to_set
changes.cycle do |change|
    freq += change
    if seen.include? freq
        puts freq
        break
    else
        seen.add freq
    end
end
