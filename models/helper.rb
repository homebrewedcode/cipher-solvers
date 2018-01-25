class Helper

    #scrub some common characters from the string
    def self.scrub_input(text)
        scubbed_text = text.gsub(/[,.?!@#$%^&*() ]/, '')         
    end

    def self.validate_alphabet(alphabet, alpha_only = true)
        
        #set expression based on whethere we want alpha only, or * placeholder as well as alphas
        if alpha_only
            alphabet_regex = /\A[a-zA-Z]+\z/
        else
            alphabet_regex = /\A[a-zA-Z|a-zA-Z*]+\z/
        end

        # check for proper alphabet length and proper characters
        if alphabet.length == 26 and (alphabet =~ alphabet_regex) != nil
            return true
        else
            return false
        end
    end

    #get an alpha range, send it to an array, shuffle, then rejoin back into a string, gives a random alphabet
    def self.randomize_alphabet
        alphabet = ('a'..'z').to_a.shuffle.join
    end

end