require 'sinatra'
require 'sinatra/reloader'
require_relative 'models/decode.rb'


get '/' do
    erb :index
end

post '/' do
    ciphertext = params[:ciphertext].gsub(/[!@#$%^&*.'"? ]/, '')
    encode_alphabet = params[:encode_alphabet]
    @evaluation = Decode.new(ciphertext, encode_alphabet)
    @evaluation.decode()    

    erb :index
end