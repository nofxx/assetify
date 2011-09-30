require 'sinatra'
require 'erb'

get '/' do
  @assets = Asset.all
  erb :"home.html"
end

get '/new' do
  headers = {} #"Allow"   => "BREW, POST, GET, PROPFIND, WHEN",  "Refresh" => "Refresh: 20; http://www.ietf.org/rfc/rfc2324.txt"
  body "T#{Time.now.to_i}"
end

post '/edit' do
  puts params

  body "OK"
end

get '/i' do
end


get '/u' do
end
