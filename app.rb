require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'ssdeep'
require 'tempfile'
require_relative 'models/decode.rb'
require_relative 'models/helper.rb'

enable :sessions


get '/' do
    @checked_operation = "decode"
    @alphabet = ''
    erb :'index.html', { layout: :'layout.html' }
end

post '/' do

    # verify the needed parameters are set, and trim / scrub the values
    if params[:operation] == "decode" and params[:ciphertext]
        ciphertext = Helper.scrub_input(params[:ciphertext]).strip
        decode_alphabet = params[:alphabet].strip

        # do some basic validation of the alphabet (length and alphanumeric and * characters only)
        if Helper.validate_alphabet(decode_alphabet, false)            
            @evaluation = Decode.new('', ciphertext, decode_alphabet)
            @evaluation.decode()
            @checked_operation = "decode"
            @alphabet = @evaluation.cipher_key
            erb :'index.html', { layout: :'layout.html' }
        else
            flash.now[:error] = "Make sure that the proper fields are filled in and formatted correctly."  
            erb :'index.html', { layout: :'layout.html' } 
        end              
    # verify the needed parameters are set, and trim / scrub the values    
    elsif params[:operation] == "encode" and params[:plaintext]
        plaintext = Helper.scrub_input(params[:plaintext]).strip
        encode_alphabet = params[:alphabet].strip      
        
        # do some basic validation of the alphabet (length and alphanumeric
        if Helper.validate_alphabet(encode_alphabet)
            @evaluation = Decode.new(plaintext, '', encode_alphabet)
            @evaluation.encode()
            @checked_operation = "encode"
            @alphabet = @evaluation.cipher_key
            erb :'index.html', { layout: :'layout.html' }
        else
            flash.now[:error] = "Make sure that the proper fields are filled in and formatted correctly."  
            erb :'index.html', { layout: :'layout.html' } 
        end       

    else
        flash.now[:error] = "Make sure that the proper fields are filled in and formatted correctly."  
        erb :'index.html', { layout: :'layout.html' }      
    end
end

post '/random' do
    @checked_operation = "encode"
    @alphabet = Helper.randomize_alphabet
    erb :'index.html', { layout: :'layout.html' }
end

get '/fuzzy-hash' do
    
    erb :'upload.html', { layout: :'layout.html' } 
end

post '/fuzzy-hash' do
       
    file1 = params[:file1][:tempfile]
    file2 = params[:file2][:tempfile]
    begin
    
        hash1 = Ssdeep.from_file("#{file1.path}")
        hash2 = Ssdeep.from_file("#{file2.path}")
        result = Ssdeep.compare(hash1, hash2)
        
        "#{hash1} : #{file1.path}"
        "#{hash2} : #{file1.path}"
        "#{result}"
    ensure
        file1.close!
        file2.close!
    end
    
end
    