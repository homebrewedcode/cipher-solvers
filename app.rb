require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
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

    elsif params[:operation] == "encode" and params[:plaintext]
        plaintext = Helper.scrub_input(params[:plaintext]).strip
        encode_alphabet = params[:alphabet].strip      

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
    @alphabet = Helper.randomize_alphabet
    erb :'index.html', { layout: :'layout.html' }
end
    