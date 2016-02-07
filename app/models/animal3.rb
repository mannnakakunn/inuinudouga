# encoding: utf-8

# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'
require 'uri'

@keys = {
  感動: "心揺さぶる,涙,助け,救う,感動,セラピー,保護犬,迷い犬,再会,胸打,rescued,homeless,",
  かわいい: "かわいい,カワイイ,可愛い,子犬,息子,赤ちゃん,仔犬,ゴールデンレトリバー,少女,フレンチブルドッグ,ポメラニアン,秋田犬,かわいすぎる,孫,puppy",
  おもしろ: "激オコ,51匹,小春,カゴ,うとうと,寝落ち,ウトウト,Jumping,ダッシュ,二足歩行,歌う,バカ,いびき,爆笑,芸,面白い,面白,おもしろ,funny",
  ハウツー: "しつけ,躾,躾け,トレーニング,無駄吠え,対処法,方法,手法,解説,how",
  " ": " "
}

def searchTag(s)-
  @keys.each do |k, v|
    words = v.split(",")
    # キーワードをカンマで分割し配列にする
    words.detect do |word|
    # 配列をぽんぽんいれていき、中身を見ていくよ
      return k if s.index(word)
      # もしキーワードをdetectした場合、タグを返すよ。のはずが、nilを返せずに、すべての@keysを出力してしまうのはなんだろう・・
      # 原因の推定：１　kの定義がいかれている説。splitはうまくいってる。 
    end
  end
end


urls =[]
search_doc=Nokogiri::HTML(open('http://www.animal-planet.jp/dogguide/directory/'))
# 解析対象URLと解析準備
search_doc.xpath('//span[@class="txtb"]').each do |search_term2|
search_term3=search_term2.inner_text
search_term=URI.encode(search_term2.inner_text+"犬 -Domination -凶暴 -妖怪 -志村 -【本】-野犬　-襲う -閲覧注意 -乱暴 -MAD -メタルギア -実況 -危険 -野生 -享年 -不倫 -交尾 -グロ -注意 -心臓 -放送事故 -広井 -ダウン症 -予告編 -MV -AKB -松井 -松紳 -俺は野良犬 -虹の橋 -おとじっけん -ベネッセ -透明な犬")
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

        if fav > 10 then

        dog = Dog.new
        dog.name=doc.xpath("//*[@id='watch7-user-header']/div/a").text
      
        dog.genre=search_term3

        dog.title = doc.xpath("//h1['watch-headline-title']/span").text.gsub(/¥n/,'')
        
        dog.tag_list=search_term3,searchTag(dog.title)
        # かわいい
        # gsubとはつまり、第１引数に一致する部分を第２引数に置き換える正規表現メソッド。
        # つまりここでは改行、スペース一つに置き換える文章整形のための記述。
        imageid=url.match(/\?([^&]+)/).to_s.sub("?v=","")
        dog.mvid="http://i.ytimg.com/vi/#{imageid}"
        dog.length=doc.xpath("//meta[@itemprop='duration']/@content").text.sub("PT","").sub("M","分").sub("H","時間").sub("S","秒")
        
        # dog.description = doc.xpath("//p[@id='eow-description']").text
        dog.post_date=date
        dog.watch = doc.xpath("//*[@class='watch-view-count']").text.gsub(/(\d{0,3}),(\d{3})/, '\1\2')
        
        # //div[@class='watch-view-count']
        dog.fav = doc.xpath("//*[@id='watch8-sentiment-actions']/span/span[1]/button/span").text
        # # 単純に、テキストをぶっこぬいてる。
        dog.url = url
          if Dog.find_by(url: dog.url).nil? then 
            dog.save
          else
          end
        else
        end  
    #　一旦、犬種を吐き出す
   end
    urls =[]
    puts search_term3+"関係情報を取得"
end