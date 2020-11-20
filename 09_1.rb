require 'pp'

class Marble
    attr_accessor :points, :pred, :succ

    def initialize(points)
        @points = points
    end

    def insert_after(marble)
        marble.succ = self.succ
        self.succ.pred = marble
        marble.pred = self
        self.succ = marble        
    end

    def remove
        self.succ.pred = self.pred
        self.pred.succ = self.succ
    end

    def get_cw(n)
        marble = self
        n.times { marble = marble.succ }
        marble
    end

    def get_ccw(n)
        marble = self
        n.times { marble = marble.pred }
        marble
    end
end

while raw_input = gets
    input = raw_input.split
    players = input[0].to_i
    rounds = input[6].to_i
    scores = [0] * players

    # puts players, rounds

    current = Marble.new(0)
    current.pred = current
    current.succ = current

    # pp [current.points]

    rounds.times do |round|
        points = round + 1
        if points % 23 == 0
            player = round % players
            scores[player] += points
            marble = current.get_ccw(7)
            scores[player] += marble.points
            marble.remove
            current = marble.succ
        else
            marble = Marble.new(points)
            current.succ.insert_after(marble)
            current = marble
        end

        # marble = current
        # marbles = []
        # loop do
        #     marbles << marble.points
        #     marble = marble.succ
        #     break if marble == current
        # end
        # pp marbles
    end

    puts scores.max
end
