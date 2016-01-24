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
      { "count": 231, "name": "奇点临近", "title": "奇点临近" },
      { "count": 194, "name": "科学", "title": "科学" },
      { "count": 147, "name": "奇点", "title": "奇点" },
      { "count": 138, "name": "进化", "title": "进化" }
    ],
    "origin_title": "the singularity is near",
    "image": "https://img1.doubanio.com/mpic/s7645423.jpg",
    "binding": "平装",
    "translator": ["李庆诚", "董振华", "田源"],
    "catalog": "摘要\n对本书的赞誉\n译者序\n前言\n致谢\n作者简介\n第1章六大纪元\n直觉的线性增长观与历史的指数增长观\n（略）",
    "ebook_url": "http://read.douban.com/ebook/1145651/",
    "pages": "373",
    "images": {
      "small": "https://img1.doubanio.com/spic/s7645423.jpg",
      "large": "https://img1.doubanio.com/lpic/s7645423.jpg",
      "medium": "https://img1.doubanio.com/mpic/s7645423.jpg"
    },
    "alt": "http://book.douban.com/subject/6855803/",
    "id": "6855803",
    "publisher": "机械工业出版社",
    "isbn10": "7111358899",
    "isbn13": "9787111358893",
    "title": "奇点临近",
    "url": "http://api.douban.com/v2/book/6855803",
    "alt_title": "the singularity is near",
    "author_intro": "雷·库兹韦尔他曾发明了盲人阅读机、音乐合成器和语音识别系统。为此他获得许多奖项：（略）",
    "summary": "人工智能作为21世纪科技发展的最新成就，深刻揭示了科技发展为人类社会带来的巨大影响。（略）",
    "ebook_price": "35.00",
    "price": "69.00元"
  },
  "book_id": "6855803",
  "id": 898248956
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