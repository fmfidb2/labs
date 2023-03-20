require 'bundler'
require 'bundler/setup'
require 'open-uri'
require 'nokogiri'
require 'active_record'
require 'pg'

=begin
create table stops (
  id serial primary key,
  name text,
  zone integer
)

create table connections (
   id serial primary key,
   start_stop_id integer references stops,
   end_stop_id   integer references stops,
   duration      integer,
   line          text      
)
=end

class StopInfo < Struct.new(:stop, :duration); end

class Stop < ActiveRecord::Base
  belongs_to :line
end

class Connection < ActiveRecord::Base
  belongs_to :start_stop, class_name: Stop
  belongs_to :end_stop, class_name: Stop
end

ActiveRecord::Base.establish_connection(adapter: 'postgresql', host: 'localhost', port: 5432, user: 'postgres', database: 'pdt')

list = Nokogiri::HTML(open('http://imhd.zoznam.sk/ba/cestovne-poriadky.html'))
list.search('.linka').map { |e| e[:href] }.each do |line_url|
  doc = Nokogiri::HTML(open("http://imhd.zoznam.sk#{line_url}"))
  detail_url = doc.search('.tabulka:first tr:nth-child(3) a:first').first[:href]

  plan_doc = Nokogiri::HTML(open("http://imhd.zoznam.sk#{detail_url}"))

  line_no = plan_doc.search('.linka').first.text

  puts "Line #{line_no}"

  stops = plan_doc.search('.zastavky_riadok').map do |tr|
    tds = tr.search('td')
    duration = tds[0].text.to_i
    stop = tds[2].text.gsub("\u00A0", " ")
    zone = tds[3].text

    puts "#{stop} (#{zone}) -> #{duration}"

    stop = Stop.where(name: stop, zone: zone).first_or_create
    StopInfo.new(stop, duration)
  end

  stops.each_cons(2) do |connection|
    Connection.create!(start_stop: connection[0].stop, end_stop: connection[1].stop, duration: connection[1].duration - connection[0].duration, line: line_no)
  end

  sleep 5
end
