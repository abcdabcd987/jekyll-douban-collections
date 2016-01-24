# jekyll-douban-collections

List your Douban collections of books and movies in Jekyll.

## Configuration in `_config.yml`

```yaml
douban-collections:
  username: <your Douban username>
```

## Example usage

List all books in a markdown page:

```markdown
{% for book in douban['books'] %}
- {{ book['updated'] | date: '%B %d, %Y' }}: [{{ book['book']['title'] }}](http://book.douban.com/subject/{{ book['book_id'] }}) {% endfor %}
```