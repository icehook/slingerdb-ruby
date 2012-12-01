$:.push File.join(File.dirname(__FILE__), '../lib')
require 'slingerdb'
require 'benchmark'
require 'pp'

include SlingerDB

endpoint, api_key, file = ARGV[0], ARGV[1], ARGV[2]

SlingerDB.config =  { :endpoint => endpoint, :api_key => api_key }

response = Request.get '/downloads.json'

f = File.open(ARGV[2], 'w')
f.puts "<html>\n<body>\n"

response.env[:body][:downloads].each do |attributes|
  d = Download.new attributes
  f.puts "<b>id:</b> #{d.id} <b>status:</b> #{d.status} <b>cdr_count:</b> #{d.cdr_count} <b>download:</b> <a href='#{d.download_uri}?share_key=#{d.share_key}'>#{d.name}</a><br/>"
end

f.puts "<body>\n<html>"
f.close

