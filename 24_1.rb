require 'pp'

Group = Struct.new(:army, :units, :hitpoints, :immunities, :weaknesses, :damage, :attack, :initiative)

def parse_group(army, line)
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
        group = Group.new(army, units, hitpoints, immunities, weaknesses, damage, attack, initiative)
    else
        units = parts[0].split[0].to_i
        hitpoints = parts[0].split[4].to_i

        immunities = []
        weaknesses = []

        damage = parts[0].split[12].to_i
        attack = parts[0].split[13]
        initiative = parts[0].split[17].to_i
        group = Group.new(army, units, hitpoints, immunities, weaknesses, damage, attack, initiative)
    end
end

groups = []
army = :immune_system
while line = gets
    next if line.include?(':')
    if line.strip.empty?
        army = :infection
        next
    end

    groups << parse_group(army, line)
end

immune_system_groups = groups.count do |group|
    group.army == :immune_system
end

infection_groups = groups.count do |group|
    group.army == :infection
end

while immune_system_groups > 0 && infection_groups > 0
    groups.sort_by! do |group|
        [-group.units * group.damage, -group.initiative]
    end

    targets = {}
    groups.each_with_index do |attacker, a|
        defender = groups.each_with_index.reject do |defender, d|
            defender.army == attacker.army || targets.has_value?(d)
        end.max_by do |defender, d|
            damage_to_defender = attacker.units * attacker.damage
            damage_to_defender = 0 if defender.immunities.include?(attacker.attack)
            damage_to_defender = 2 * attacker.units * attacker.damage if defender.weaknesses.include?(attacker.attack)
            [damage_to_defender, defender.units * defender.damage, defender.initiative]
        end

        targets[a] = defender[1] unless defender.nil? || defender[0].immunities.include?(attacker.attack)
    end

    attacker_ids = (0...groups.size).to_a.sort_by! do |i|
        -groups[i].initiative
    end

    attacker_ids.each do |a|
        d = targets[a]
        next if d.nil?
        next unless groups[a].units > 0

        damage_to_defender = groups[a].units * groups[a].damage
        damage_to_defender = 0 if groups[d].immunities.include?(groups[a].attack)
        damage_to_defender = 2 * groups[a].units * groups[a].damage if groups[d].weaknesses.include?(groups[a].attack)

        groups[d].units -= damage_to_defender / groups[d].hitpoints
    end

    groups = groups.select do |group|
        group.units > 0
    end

    immune_system_groups = groups.count do |group|
        group.army == :immune_system
    end
    
    infection_groups = groups.count do |group|
        group.army == :infection
    end
end

remaining_units = groups.map do |group|
    group.units
end

puts remaining_units.sum
