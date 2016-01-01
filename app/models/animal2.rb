# encoding: utf-8

# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'
require 'uri'

urls =[]
search_doc=Nokogiri::HTML(open('http://www.animal-planet.jp/dogguide/directory/'))
# 解析対象URLと解析準備
search_doc.xpath('//span[@class="txtb"]').each do |search_term2|
search_term3=search_term2.inner_text
search_term=URI.encode(search_term2.inner_text+"犬")
# 解析結果をぶちこむ
url="https://www.youtube.com/results?search_query=#{search_term}"

    doc=Nokogiri::HTML(open(url))
    # ノコギリで、urlを開いてdocという変数へ入れる。
    elements=doc.xpath("//h3[@class='yt-lockup-title ']/a")
    # 要素の切り出しをxpathを使って行う。　h３タグでyt-lookup-title（注意：末尾に半角スペース１つ入ります！）というクラスが付与された要素下のa要素を取得。
    elements.each do |a|
    # その中のリンク要素それぞれを取り出す。
    code = a.attributes['href'].value
    # そして、その要素が持つhref属性、すなわちアドレスを取得する。
    urls << "https://www.youtube.com" + code if code.include?('watch')
    # 配列宣言しておいたurlsにそれぞれのアドレスをお尻に付加した、youtubeのアドレスをぶっこんでいく。
    end
    # doc=Nokogiri::HTML(open(url))
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

    urls.each do |url|
    # それぞれのurlについて情報を吐き出させる。
      doc =Nokogiri::HTML(open(url),nil,"UTF-8")
      fav = doc.xpath("//*[@id='watch8-sentiment-actions']/span/span[1]/button/span").text.to_s.to_i
      date = doc.xpath("//meta[@itemprop='datePublished']/@content").text

      if fav > 100 then

      dog =Dog.new
      dog.name=doc.xpath("//*[@id='watch7-user-header']/div/a").text
      dog.genre=search_term3
      dog.tag_list=search_term3
      dog.title = doc.xpath("//h1['watch-headline-title']/span").text.gsub(/¥n/,'')
      # gsubとはつまり、第１引数に一致する部分を第２引数に置き換える正規表現メソッド。
      # つまりここでは改行、スペース一つに置き換える文章整形のための記述。
      imageid=url.match(/\?([^&]+)/).to_s.sub("?v=","")
      dog.mvid="http://i.ytimg.com/vi/#{imageid}/mqdefault.jpg"
      dog.length=doc.xpath("//meta[@itemprop='duration']/@content").text.sub("PT","").sub("M","分").sub("H","時間").sub("S","秒")
      # dog.description = doc.xpath("//p[@id='eow-description']").text
      
      dog.post_date=date
      dog.watch = doc.xpath("//*[@class='watch-view-count']").text.gsub(/(\d{0,3}),(\d{3})/, '\1\2')
      
      # //div[@class='watch-view-count']
      dog.fav = doc.xpath("//*[@id='watch8-sentiment-actions']/span/span[1]/button/span").text
      # # 単純に、テキストをぶっこぬいてる。
      dog.url = url
      dog.save
      else
      end
    end
    #　一旦、犬種を吐き出す
    urls =[]
    puts search_term3
end