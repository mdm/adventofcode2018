require 'set'
require 'pp'

$unmarked = Set.new
$edges = []
$ordering = []
while raw_edge = gets
    from = raw_edge.split[1]
    to = raw_edge.split[7]
    $unmarked.add(from)
    $unmarked.add(to)
    $edges << [from, to]
    # puts "#{from} -> #{to};"
end
$unmarked = $unmarked.to_a.sort.reverse

def visit(node)
    return unless $unmarked.include?(node)

    candidates = []
    $edges.each do |edge|
        candidates << edge[1] if edge[0] == node
    end
    
    candidates.sort.reverse.each do |candidate|
        visit(candidate)
    end

    $unmarked.delete(node)
    $ordering << node
end

until $unmarked.empty?
    visit($unmarked.first)
end

puts $ordering.reverse.join
