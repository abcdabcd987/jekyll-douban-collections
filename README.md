# jekyll-douban-collections

在 Jekyll 中列出你在豆瓣上的书和电影。

## 安装依赖

```sh
gem install nokogiri
```

## 设置 `_config.yml`

```yaml
douban-collections:
  username: <your Douban username>
  cache: true
```

## 例子

用 Markdown 格式列出所有的书和电影：

```markdown
## Books

{% for book in douban['books'] %}
- {{ book['updated'] | date: '%B %d, %Y' }}: [{{ book['book']['title'] }}](http://book.douban.com/subject/{{ book['book_id'] }}) {% endfor %}

## Movies

{% for movie in douban['movies'] %}
- {{ movie['date'] | date: '%B %d, %Y' }}: [{{ movie['title_original'] }}](http://movie.douban.com/subject/{{ movie['movie_id'] }}) {% endfor %}
```

如果只列出2015年的书和电影，可以这样：

```markdown
## Books

{% for book in douban['books'] %}{% capture date %}{{ book['updated'] | date: %F }}{% endcapture %}{% if '2015-00-00' < date and date < '2016-00-00' %}
- {{ book['updated'] | date: '%B' }}: [{{ book['book']['title'] }}](http://book.douban.com/subject/{{ book['book_id'] }}) {% endif %}{% endfor %}

## Movies

{% for movie in douban['movies'] %}{% capture date %}{{ movie['date'] | date: %F }}{% endcapture %}{% if '2015-00-00' < date and date < '2016-00-00' %}
- {{ movie['date'] | date: '%B %d' }}: [{{ movie['title_original'] }}](http://movie.douban.com/subject/{{ movie['movie_id'] }}) {% endif %}{% endfor %}
```

## `douban['books']`中的元素信息：

书的信息通过豆瓣API得到，所以很全面。下面是一个例子：

```json
{
  "status": "wish",
  "updated": "2015-02-28 10:31:02",
  "user_id": "49429397",
  "book": {
    "rating": { "max": 10, "numRaters": 557, "average": "8.0", "min": 0 },
    "subtitle": "当计算机智能超越人类",
    "author": ["Ray Kurzweil"],
    "pubdate": "2011-10",
    "tags": [
      { "count": 1045, "name": "人工智能", "title": "人工智能" },
      { "count": 569, "name": "未来学", "title": "未来学" },
      { "count": 378, "name": "计算机", "title": "计算机" },
      { "count": 302, "name": "科普", "title": "科普" },
:
被称为犯罪群体的群体\n3．刑事案件的陪审团\n4．选民群体\n5．议会\n译名对照表",
    "ebook_url": "http://read.douban.com/ebook/11173912/",
    "pages": "183",
    "images": {
      "small": "https://img1.doubanio.com/spic/s1988393.jpg",
      "large": "https://img1.doubanio.com/lpic/s1988393.jpg",
      "medium": "https://img1.doubanio.com/mpic/s1988393.jpg"
    },
    "alt": "http://book.douban.com/subject/1012611/",
    "id": "1012611",
    "publisher": "中央编译出版社",
    "isbn10": "7801093666",
    "isbn13": "9787801093660",
    "title": "乌合之众",
    "url": "http://api.douban.com/v2/book/1012611",
    "alt_title": "Psychologie des Foules",
    "author_intro": "古斯塔夫・勒庞 Gustave Le Bon(1841-1931) 法国著名社会心理学家。他自1894年始，写下一系列社会心理学著作，以本书最为著名，被 翻译成近二十种语言，至今仍在国际
学术界有广泛影响。\n\n",
    "summary": "古斯塔夫・勒庞 Gustave Le Bon(1841-1931) 法国著名社会心理学家。他自1894年始，写下一系列社会心理学著作，以本书最为著名；在社会心理学领域已有的著作中，最有影响的
，也是这本并不很厚的《乌合之众》。古斯塔夫・勒庞在他在书中极为精致地描述了集体心态，对人们理解集体行为的作用以及对社会心理学的思考发挥了巨大影响。《乌合之众--大众心理研究》在西方已印至第29版，其观点新颖，语言生动，是群体行为的研究者不可不读的佳作。",
    "ebook_price": "5.99",
    "price": "16.00元"
  },
  "book_id": "1012611",
  "id": 908077939
}
```

## `douban['movies']`中的元素信息：

因为豆瓣没有提供电影API，所以只能手动爬网页，信息量比较少。下面是一个例子：

```json
{
    "title": "饥饿游戏",
    "title_original": "The Hunger Games",
    "date": "2013-05-25",
    "movie_id": "3592853",
    "intro": "2012-03-23(美国) / 2012-06-14(中国大陆) / 詹妮弗·劳伦斯 / 乔什·哈切森 / 利亚姆·海姆斯沃斯 / 韦斯·本特利 / 伊丽莎白·班克斯 / 斯坦利·图齐 / 伍迪·哈里森 / 伊莎贝拉·弗尔曼 / 阿曼德拉·斯坦伯格  / 薇洛·西尔德斯 / 唐纳德·萨瑟兰 / 亚历山大·路德韦格 / 莱文·兰宾 / 杰克·奎德 / 美国 / www.thehungergamesmovie.com / 盖瑞·罗斯 / 142分钟 / 饥饿游戏 / 动作 / 科幻 / 冒险 / 苏珊·科林斯 Suzanne Collins / 比利·雷 Billy Ray / 加里·罗斯 Gary Ross / 英语",
    "pic": "http://img3.douban.com/view/movie_poster_cover/ipst/public/p1460591675.jpg"
}
```

## 关于缓存

如果收藏的电影多的话，每次生成需要爬的页面比较多，通过开启缓存可以只爬取新的收藏记录。 如果开启缓存会建立 `.douban-collection-cache/` 缓存文件夹。