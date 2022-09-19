require 'securerandom'

module RandomNumber
    def random_hex_string(n)
      SecureRandom.hex(n)
    end
end

Liquid::Template.register_filter(RandomNumber)
