require 'pp'
require 'set'

ip_register = gets.split.last.to_i
instructions = []
while instruction = gets
    instruction = instruction.split.each_with_index.map do |part, i|
        if i == 0
            part.to_sym
        else
            part.to_i
        end
    end
    instructions << instruction
end
pp instructions

def addr(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] + registers[b]
    registers
end

def addi(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] + b
    registers
end

def mulr(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] * registers[b]
    registers
end

def muli(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] * b
    registers
end

def banr(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] & registers[b]
    registers
end

def bani(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] & b
    registers
end

def borr(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] | registers[b]
    registers
end

def bori(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] | b
    registers
end

def setr(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a]
    registers
end

def seti(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = a
    registers
end

def gtir(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = a > registers[b] ? 1 : 0
    registers
end

def gtri(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] > b ? 1 : 0
    registers
end

def gtrr(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] > registers[b] ? 1 : 0
    registers
end

def eqir(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = a == registers[b] ? 1 : 0
    registers
end

def eqri(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] == b ? 1 : 0
    registers
end

def eqrr(instruction, registers)
    opcode, a, b, c = instruction
    registers[c] = registers[a] == registers[b] ? 1 : 0
    registers
end


registers = [0] * 6
ip = 0
executed = 0
trace = false
history = Set.new
while ip >= 0 && ip < instructions.size
    registers[ip_register] = ip
    pp ip, registers if trace
    instruction = instructions[ip]
    pp instruction if trace
    if ip == 28
        pp ['!', instruction, registers]
        break if history.include?(registers[4])
        history.add(registers[4])
    end
    registers = send(instruction[0], instruction, registers)
    registers[0] = 11840402 if ip == 28
    ip = registers[ip_register]
    executed += 1
    pp registers if trace
    puts if trace
    ip += 1
    # break if executed == 5
end

puts 'HALT'
