require 'pp'

Group = Struct.new(:units, :hitpoints, :immunities, :weaknesses, :damage, :attack, :initiative)

def parse_group(line)
    parts = line.strip.split(/\(|\)/)
    
    if parts.size == 3
        units = parts[0].split[0].to_i
        hitpoints = parts[0].split[4].to_i

        immunities = []
        weaknesses = []
        parts[1].split('; ').each do |modifiers|
            if modifiers.split[0] == 'immune'
                immunities = modifiers.split().drop(2).join.split(',')
            else
                weaknesses = modifiers.split().drop(2).join.split(',')
            end            
        end

        damage = parts[2].split[5].to_i
        attack = parts[2].split[6]
        initiative = parts[2].split[10].to_i
        group = Group.new(units, hitpoints, immunities, weaknesses, damage, attack, initiative)
    else
        units = parts[0].split[0].to_i
        hitpoints = parts[0].split[4].to_i

        immunities = []
        weaknesses = []

        damage = parts[0].split[12].to_i
        attack = parts[0].split[13]
        initiative = parts[0].split[17].to_i
        group = Group.new(units, hitpoints, immunities, weaknesses, damage, attack, initiative)
    end
end

armies = [[]]
while line = gets
    next if line.include?(':')
    if line.strip.empty?
        armies << []
        next
    end

    armies.last << parse_group(line)
end

pp armies
