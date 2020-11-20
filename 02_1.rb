require 'set'
require 'pp'

doubles = 0
triples = 0
while id = gets
    sorted = id.chars.sort
    last = nil
    count = nil
    no_double = true
    no_triple = true
    sorted.each do |char, imńdex|
        if char == last
            count += 1
        else
            if count == 3 && no_triple
                triples += 1
                no_triple = false
            end
            if count == 2 && no_double
                doubles += 1
                no_double = false
            end
            count = 1
        end
        last = char
    end

    if count == 3 && no_triple
        triples += 1
        no_triple = false
    end
    if count == 2 && no_double
        doubles += 1
        no_double = false
    end
    count = 1
end

puts doubles * triples
