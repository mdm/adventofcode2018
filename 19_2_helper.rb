n = 10551277
sum = 0
(1..n).each do |i|
    if n % i == 0
        puts i
        sum += i
    end
end
puts 'done.'
puts sum
