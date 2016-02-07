# encoding: utf-8

# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'
require 'uri'

urls =[]
search_doc=Nokogiri::HTML(open('http://www.animal-planet.jp/dogguide/directory/'))
# 解析対象URLと解析準備
links = search_doc.xpath("//td[1]/a")
#それぞれの個別のリンクについて解析するため a属性を取得し代入する
links.each do |link|

doglink=link.attributes['href'].value
dog_doc=Nokogiri::HTML(open('http://www.animal-planet.jp/dogguide/directory/'+doglink))

name=dog_doc.xpath("//div[@id='title']/h3/span").inner_text
en_name=dog_doc.xpath("//div[@id='h3txt']").inner_text

puts name+"("+en_name+")の特性"
puts

disease1=dog_doc.xpath("//tr/td[@class='td2r']").inner_text
# 特に注意すべき病気について取得する

rates=dog_doc.xpath("//td/img")
# 評価を取得していく
i=0

rates.each do |rate|
i += 1
case i

when 1 then
puts "活発度"
puts rate.attributes['alt'].value

when 2 then
puts "必要運動量"
puts rate.attributes['alt'].value

when 3 then
puts "遊び好き度"
puts rate.attributes['alt'].value

when 4 then
puts "人なつこさ"
puts rate.attributes['alt'].value

when 5 then
puts "犬に対する友好度"
puts rate.attributes['alt'].value

when 6 then
puts "他のペットに対する友好度"
puts rate.attributes['alt'].value

when 7 then
puts "知らない人に対する友好度"
puts rate.attributes['alt'].value

when 8 then
puts "しつけやすさ"
puts rate.attributes['alt'].value

when 9 then
puts "番犬適正"
puts rate.attributes['alt'].value

when 10 then
puts "防衛能力"
puts rate.attributes['alt'].value

when 11 then
puts "手入れ"
puts rate.attributes['alt'].value

when 12 then
puts "耐寒能力"
puts rate.attributes['alt'].value

when 13 then
puts "対暑能力"
puts rate.attributes['alt'].value
puts
end
end
end
