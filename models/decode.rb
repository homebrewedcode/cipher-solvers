class Decode
    attr_reader :ciphertext, :plaintext, :cipher_key

    def initialize(plaintext = '', ciphertext = '', cipher_key )
        @ciphertext = ciphertext.downcase
        @cipher_key = cipher_key.downcase
        @plaintext = plaintext.downcase
        @decryption_hash = map_alphabet

    end
    
    def map_alphabet
        # split the cipher alphabet into an array, make a natural alphabet array, then create a hash to map them to each other
        cipherkey_array = @cipher_key.split(//)      
        alphabet = ('a'..'z').to_a   
        @decryption_hash = Hash[alphabet.map.with_index { |plain, index| [ plain, cipherkey_array[index] ] }]
    end

    def decode
        # place our cipher text into array, step through each character and bounce against our hash
        ciphertext_array = @ciphertext.split(//)
        ciphertext_array.each {|char| @plaintext += @decryption_hash.key(char).to_s}

    end

    def encode
        # place our plain text into array, step through each character and bounce against our hash
        plaintext_array = @plaintext.split(//)
        plaintext_array.each {|char| @ciphertext += @decryption_hash[char].to_s}
    end

end

# Some early test code
# cipher_alphabet = 'PHQGIBMEAULNOFDXJKRCVSTZWY'

# cipher = 'tpfccdlfdtte pcaccplircdt dklpcfrp?qeiq lhpqlipqeodf gpwafopwprti izxndkiqpkii krirrifcapnc dxkdciqcafmd vkfpcadf'.gsub(/[!@#$%^&*.'"? ]/, '')
# cipher.downcase!
# cipher.strip!
# toy = Decode.new(cipher, cipher_alphabet, '')
# decoded = toy.decode()
# # puts decoded
# # puts toy.ciphertext
# # puts toy.plaintext

# # plaintext = 'wanttoknowwhatittakestoworkatnsacheckbackeachmondayinmayasweexplorecareersessentialtoprotectingournation'
# # test = Decode.new('', cipher_alphabet, plaintext)
# # test.encode
# # puts test.ciphertext
# # puts test.cipher_key