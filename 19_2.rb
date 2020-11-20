require 'pp'

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
registers[0] = 1
ip = 0
executed = 0
trace = false
skipped = false
while ip >= 0 && ip < instructions.size
    registers[ip_register] = ip
    pp ip, registers if trace
    instruction = instructions[ip]
    pp instruction if trace
    if ip == 3
        pp ['?', registers]
    end
    if ip == 13
        pp ['!', registers]
        # unless skipped
        #     registers = [12, 10551278, 10551277, 121, 1, 13]
        #     skipped = true
        # end
    end
    registers = send(instruction[0], instruction, registers)
    ip = registers[ip_register]
    executed += 1
    pp registers if trace
    puts if trace
    ip += 1
end

pp registers[0]
