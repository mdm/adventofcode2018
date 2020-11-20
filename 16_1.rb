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

ambiguous = 0
samples.each do |sample|
    plausible = 0
    ops.each do |op|
        before, instruction, after = sample
        result = send(op, instruction, before.clone)
        # pp [op, sample, result, result == after]
        plausible += 1 if result == after
    end
    # puts
    ambiguous += 1 if plausible >= 3
end

pp [ambiguous, samples.size]
