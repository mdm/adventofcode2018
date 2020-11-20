require 'set'
require 'pp'

unmarked = Set.new
edges = []
while raw_edge = gets
    from = raw_edge.split[1]
    to = raw_edge.split[7]
    unmarked.add(from)
    unmarked.add(to)
    edges << [from, to]
    # puts "#{from} -> #{to};"
end
unmarked = unmarked.to_a.sort

total = 0
steps = []
times = []
workers = 5
while unmarked.size > 0
    new_steps = unmarked.reject do |node|
        edges.any? do |edge|
            edge[1] == node
        end
    end.take(workers - times.size)

    new_steps.each do |step|
        unmarked.delete(step)
        steps << step
        times << (step.ord - 'A'.ord + 61)
    end

    total += times.min
    times = times.map do |time|
        time - times.min
    end

    done_steps = steps.select.with_index do |step, i|
        times[i] == 0
    end

    done_steps.each do |step|
        edges = edges.reject do |edge|
            edge[0] == step
        end
    end

    steps = steps.reject.with_index do |step, i|
        times[i] == 0
    end

    times = times.reject do |time|
        time == 0
    end
end

puts total
