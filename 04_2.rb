require 'pp'

events = []
while event = gets
    events << event
end

events = events.sort_by do |event|
    event.split.take(2).join
end

guards = {}
schedules = {}
current_id = nil
current_start = nil
events.each do |event|
    parts = event.split
    if parts.last == 'shift'
        current_id = parts[3].chars.drop(1).join.to_i
        # puts current_id
        next
    end

    if parts.last == 'asleep'
        current_start = parts[1][3..4].to_i
        # puts current_start
        next
    end

    if parts.last == 'up'
        current_end = parts[1][3..4].to_i
        if guards[current_id].nil?
            guards[current_id] = 0
            schedules[current_id] = [0] * 60
        end
        guards[current_id] += current_end - current_start
        (current_start..(current_end) - 1).each do |minute|
            schedules[current_id][minute] += 1
        end
        # puts current
    end

    # puts event
end

max_guard = nil
max_times = 0
max_minute = nil
guards.each_pair do |guard, minutes|
    if schedules[guard].max > max_times
        max_guard = guard
        max_times = schedules[guard].max
        max_minute = schedules[guard].index(max_times)
    end
end


puts max_guard * max_minute