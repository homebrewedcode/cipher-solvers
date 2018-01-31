require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
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
    @result = false
    erb :'fuzzy-hash.html', { layout: :'layout.html' } 
end

post '/fuzzy-hash' do
    
    if params[:file1] and params[:file2]
        file1 = params[:file1][:tempfile]
        file2 = params[:file2][:tempfile]
        
        begin
    
            hash1 = `ssdeep -b #{file1.path} > hashes.txt`
            @result = `ssdeep -b -m hashes.txt #{file2.path}`
            
            if @result.empty?
                @result = "0"
            else
                @result = @result.slice(-7..-2).gsub(/[a-zA-Z() ]/, '') if @result
            end

        ensure
        
            file1.close!
            file2.close!
        end
        
        erb :'fuzzy-hash.html', { layout: :'layout.html' } 
    else
        flash.now[:error] = "Make sure that you have entered files in both fields."
        erb :'fuzzy-hash.html', { layout: :'layout.html' } 
    end
    
end
    