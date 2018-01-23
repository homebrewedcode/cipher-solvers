class Decode
    attr_reader :ciphertext, :plaintext

    def initialize(ciphertext, cipher_key)
        @ciphertext = ciphertext
        @cipher_key = cipher_key
        @plaintext = ''        
    end

    def decode()
        # split the cipher alphabet into an array, make a natural alphabet array, then create a hash to map them to each other
        cipher_array = @cipher_key.split(//)      
        alphabet = ('a'..'z').to_a   
        decryption_hash = Hash[alphabet.map.with_index { |plain, index| [ plain, cipher_array[index] ] }]


        # place our cipher text into array, step through each character and bounce against our hash
        cipher_array = @ciphertext.split(//)
        cipher_array.each {|char| @plaintext += decryption_hash.key(char.upcase)}

    end

end

# Some early test code
# cipher_alphabet = 'PHQGIBMEAULNOFDXJKRCVSTZWY'

# cipher = 'tpfccdlfdtte pcaccplircdt dklpcfrp?qeiq lhpqlipqeodf gpwafopwprti izxndkiqpkii krirrifcapnc dxkdciqcafmd vkfpcadf'.gsub(/[!@#$%^&*.'"? ]/, '')
# cipher.downcase!
# cipher.strip!
# toy = Decode.new(cipher, cipher_alphabet)
# decoded = toy.decode()
# puts decoded