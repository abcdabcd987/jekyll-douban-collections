# jekyll-douban-collections

List your Douban collections of books and movies in Jekyll.

## Install Gems

```sh
gem install nokogiri
```

## Configuration in `_config.yml`

```yaml
douban-collections:
  username: <your Douban username>
```

## Example usage

List all books and movies in a markdown page:

```markdown
## Books

{% for book in douban['books'] %}
- {{ book['updated'] | date: '%B %d, %Y' }}: [{{ book['book']['title'] }}](http://book.douban.com/subject/{{ book['book_id'] }}) {% endfor %}

## Movies

{% for movie in douban['movies'] %}
- {{ movie['date'] | date: '%B %d, %Y' }}: [{{ movie['title_original'] }}](http://movie.douban.com/subject/{{ movie['movie_id'] }}) {% endfor %}
```