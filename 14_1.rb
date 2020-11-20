require 'pp'

recipes = [3, 7]
elves = [0, 1]

cycles = 0
target = gets.to_i
loop do
    # pp [recipes, elves]
    sum = recipes[elves[0]] + recipes[elves[1]]
    new_recipes = sum.digits.reverse
    recipes.concat(new_recipes)
    
    elves = elves.map do |elf|
        # pp [elf, recipes[elf], recipes.size]
        (elf + 1 + recipes[elf]) % recipes.size
    end    

    cycles += 1
    break if recipes.size >= target + 10
end

recipes = recipes.select.with_index { |recipe, i| target <= i && i < target + 10 }
puts recipes.map { |recipe| recipe.to_s }.join