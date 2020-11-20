require 'pp'

class Node
    class << self
        def parse(data)
            num_children = data[0]
            num_metadata = data[1]
            data = data.drop(2)

            if num_children == 0
                [new([], data.take(num_metadata)), data.drop(num_metadata)]
            else
                children = []
                num_children.times do
                    child, data = parse(data)
                    children << child
                end
                [new(children, data.take(num_metadata)), data.drop(num_metadata)]
            end
        end
    end

    attr_accessor :children, :metadata

    def initialize(children, metadata)
        self.children = children
        self.metadata = metadata
    end

    def sum
        sums_children = children.map { |child| child.sum }
        sums_children.sum + metadata.sum
    end
end

root, _ = Node.parse(gets.split.map { |s| s.to_i })
puts root.sum
