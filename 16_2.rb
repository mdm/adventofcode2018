require 'pp'
require 'json'
require 'set'

samples = []
loop do
    raw_before = gets.chomp
    break if raw_before == ''
    before = JSON.parse(raw_before.split(': ').last)
    instruction = gets.split.map { |part| part.to_i }
    after = JSON.parse(gets.split(': ').last)
    gets
    samples << [before, instruction, after]
end

ops = []
ops << def addr(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] + registers[b]
    registers
end

ops << def addi(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] + b
    registers
end

ops << def mulr(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] * registers[b]
    registers
end

ops << def muli(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] * b
    registers
end

ops << def banr(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] & registers[b]
    registers
end

ops << def bani(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] & b
    registers
end

ops << def borr(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] | registers[b]
    registers
end

ops << def bori(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] | b
    registers
end

ops << def setr(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a]
    registers
end

ops << def seti(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = a
    registers
end

ops << def gtir(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = a > registers[b] ? 1 : 0
    registers
end

ops << def gtri(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] > b ? 1 : 0
    registers
end

ops << def gtrr(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] > registers[b] ? 1 : 0
    registers
end

ops << def eqir(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = a == registers[b] ? 1 : 0
    registers
end

ops << def eqri(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] == b ? 1 : 0
    registers
end

ops << def eqrr(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] == registers[b] ? 1 : 0
    registers
end

# pp [ops, ops.size]

# opcodes = Set.new
# samples.each do |sample|
#     opcodes.add(sample[1][0])
# end
# pp opcodes.to_a.sort

opcodes = [nil] * 16
unassigned = Set.new(ops)
while unassigned.size > 0
    16.times do |opcode|
        next unless opcodes[opcode].nil?
        all_candidates = []
        samples.each do |sample|
            before, instruction, after = sample
            next unless instruction[0] == opcode
            sample_candidates = Set.new
            ops.each do |op|            
                result = send(op, instruction, before.clone)
                # pp [op, sample, result, result == after]
                sample_candidates.add(op) if result == after
            end
            # puts
            all_candidates << sample_candidates
        end
        final_candidates = all_candidates.reduce(:&) & unassigned
        # pp [opcode, final_candidates]
        if final_candidates.size == 1
            opcodes[opcode] = final_candidates.to_a[0]
            pp [opcode, opcodes[opcode]]
            unassigned.delete(opcodes[opcode])
        end
    end
    puts
end

gets
registers = [0] * 4
while raw_instruction = gets
    instruction = raw_instruction.split.map { |part| part.to_i }
    registers = send(opcodes[instruction[0]], instruction, registers)    
end
pp registers[0]
