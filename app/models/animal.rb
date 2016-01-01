# encoding: utf-8

# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'
require 'uri'

search_doc=Nokogiri::HTML(open('http://www.animal-planet.jp/dogguide/directory/'))
# 解析対象URLと解析準備
search_doc.xpath('//span[@class="txtb"]').each do |search_term2|
search_term=URI.encode(search_term2.inner_text)
# 解析結果をぶちこむ
url="https://www.youtube.com/results?search_query=#{search_term}"
    # doc=Nokogiri::HTML(open(url))
puts url
    # # urlは普通に、YouTubeの検索した時のurl。
    # doc=Nokogiri::HTML(open(url))
    # # ノコギリで、urlを開いてdocという変数へ入れる。
    # elements=doc.xpath("//h3[@class='yt-lockup-title ']/a")
    # # 要素の切り出しをxpathを使って行う。　h３タグでyt-lookup-title（注意：末尾に半角スペース１つ入ります！）というクラスが付与された要素下のa要素を取得。
    # elements.each do |a|
    # # その中のリンク要素それぞれを取り出す。
    # code = a.attributes['href'].value
    # # そして、その要素が持つhref属性、すなわちアドレスを取得する。
    # urls << "https://www.youtube.com" + code if code.include?('watch')
    # # 配列宣言しておいたurlsにそれぞれのアドレスをお尻に付加した、youtubeのアドレスをぶっこんでいく。
    
end