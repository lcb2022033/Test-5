class Base62
  ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".freeze
  BASE = ALPHABET.length

  def self.encode(number)
    return ALPHABET[0] if number == 0 # special case
    result = ""

    while number > 0
      result = ALPHABET[number % BASE] + result
      number /= BASE
    end

    result
  end

  def self.decode(string)
    number = 0
    string.each_char { |char| number = number * BASE + ALPHABET.index(char) }
    number
  end
end