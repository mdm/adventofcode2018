require 'pp'

recipes = [3, 7]
elves = [0, 1]
target = gets.chomp

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

    matched = recipes[start..(recipes.size - 1)].map { |recipe| recipe.to_s }.join.index(target)
    # pp [start, recipes.size]
    if matched.nil?
        start += 1
    else
        break
    end

    cycles += 1
    pp [cycles, recipes.size] if cycles % 10000 == 0
end

puts start + matched
