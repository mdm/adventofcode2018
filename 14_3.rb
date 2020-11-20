require 'pp'

recipes = [3, 7]
elves = [0, 1]
target = gets.to_i.digits.reverse

cycles = 0
start = 0
matched = 0
loop do
    # pp [recipes, elves]
    sum = recipes[elves[0]] + recipes[elves[1]]
    new_recipes = sum.digits.reverse
    recipes.concat(new_recipes)
    
    elves = elves.map do |elf|
        # pp [elf, recipes[elf], recipes.size]
        (elf + 1 + recipes[elf]) % recipes.size
    end

    while start < recipes.size
        if recipes[start] == target[matched]
            start += 1
            matched += 1
            break if matched == target.size
        else
            start = start - matched + 1
            matched = 0
        end
    end

    # pp [start, matched, recipes, target]
    break if matched == target.size

    cycles += 1
    pp [cycles, recipes.size] if cycles % 10000 == 0
end

puts start - matched
