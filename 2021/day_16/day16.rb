# frozen_string_literal: true

class PacketDecoder < String
  attr_reader :ip

  def self.from_hex(input)
    PacketDecoder.new(input.chars.map { _1.to_i(16).to_s(2).rjust(4, '0') }.join)
  end

  def version
    self[0, 3].to_i(2)
  end

  def type_id
    self[3, 3].to_i(2)
  end

  # part 1
  # def decode
  #   if type_id == 4
  #     literal_value
  #     version
  #   else
  #     version + operator.sum
  #   end
  # end

  # part2
  def decode
    case type_id
    when 4 then literal_value
    when 0 then operator.sum
    when 1 then operator.inject(:*)
    when 2 then operator.min
    when 3 then operator.max
    when 5 then operator[0] > operator[1] ? 1 : 0
    when 6 then operator[0] < operator[1] ? 1 : 0
    when 7 then operator[0] == operator[1] ? 1 : 0
    end
  end

  def length_type_id
    self[6].to_i(2)
  end

  def bits_of_subpackets
    length_type_id.zero? ? 15 : 11
  end

  def length_of_subpackets
    self[7, bits_of_subpackets].to_i(2)
  end

  def operator
    @ip = 7 + bits_of_subpackets
    values = []

    if length_type_id.zero?
      max_ip = ip + length_of_subpackets

      add_subpacket(values) while @ip < max_ip
    else
      length_of_subpackets.times do
        add_subpacket(values)
      end
    end

    values
  end

  def add_subpacket(arr)
    subpacket = PacketDecoder.new(self[@ip..])
    arr << subpacket.decode
    @ip += subpacket.ip
  end

  def literal_value
    value = ''
    @ip = 6

    loop do
      last_package = self[ip, 5][0] == '0'
      value += self[ip, 5][1, 4]
      @ip += 5

      break value.to_i(2) if last_package
    end
  end
end

# part 1
# puts PacketDecoder.from_hex(File.read('input')).decode == 947

# part 2
puts PacketDecoder.from_hex('C200B40A82').decode == 3
puts PacketDecoder.from_hex('04005AC33890').decode == 54
puts PacketDecoder.from_hex('880086C3E88112').decode == 7
puts PacketDecoder.from_hex('CE00C43D881120').decode == 9
puts PacketDecoder.from_hex('D8005AC2A8F0').decode == 1
puts PacketDecoder.from_hex('F600BC2D8F').decode == 0
puts PacketDecoder.from_hex('9C005AC2F8F0').decode == 0
puts PacketDecoder.from_hex('9C0141080250320F1802104A08').decode == 1
puts PacketDecoder.from_hex(File.read('input')).decode == 660_797_830_937
