require "rubygems"
require "json"
require "net/http"
require "uri"
require 'nokogiri'
require 'open-uri'

def read_cache(name)
    uri = ".douban-collections-cache/#{name}.json"
    if File.exists? uri
        file = File.read(uri)
        JSON.parse(file)
    else
        []
    end
end

def write_cache(name, obj)
    if not Dir.exists? ".douban-collections-cache"
        Dir.mkdir ".douban-collections-cache"
    end
    File.open(".douban-collections-cache/#{name}.json", 'w') do |f|
        f.write(obj.to_json)
    end
end

def get_books(conf)
    puts 'douban-collections: getting books...'
    books = []

    uri = URI.parse("https://api.douban.com/v2/book/user/#{conf['username']}/collections")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    http.use_ssl = true
    response = http.request(request)
    if response.code == "200"
        result = JSON.parse(response.body)
        result['collections'].each do |doc|
            books.push doc
        end
    else
        puts "ERROR!!!"
    end

    books
end

def get_movies(conf)
    puts 'douban-collections: getting movies...'
    movies = []
    if conf['cache']
        cache = read_cache 'movies'
        cache_id = cache.size > 0 ? cache[0]['movie_id'] : 'invalid id'
    end

    uri = "http://movie.douban.com/people/#{conf['username']}/collect?sort=time&start=0&filter=all&mode=grid&tags_sort=count"
    while not uri.empty? do
        doc = Nokogiri::HTML(open(uri))
        doc.css('.item').each do |doc|
            m = {}
            doc_title = doc.css('.title em').first
            titles = doc_title.content.split(' / ')
            if titles.size == 2
                m['title'] = titles[0].strip
                m['title_original'] = titles[1].strip
            else
                m['title'] = doc_title.content.strip
                m['title_original'] = m['title']
            end
            m['date'] = doc.css('.date').first.content[/\d{4}-\d{2}-\d{2}/]
            m['movie_id'] = doc.css('.title a').first['href'][/\d+/]
            m['intro'] = doc.css('.intro').first.content
            m['pic'] = doc.css('img').first['src']
            if conf['cache'] and m['movie_id'] == cache_id
                uri = ''
                break
            end
            movies.push m
        end
        break if uri.empty?
        doc_next = doc.css('.paginator .next a')
        uri = doc_next.size > 0 ? doc_next.first['href'] : ''
    end

    if conf['cache']
        cache.each do |m|
            movies.push m
        end
        write_cache('movies', movies)
    end

    movies
end

Jekyll::Hooks.register :site, :pre_render do |site, vars|
    puts ''
    conf = site.config['douban-collections']
    vars['douban'] = {
        'books'  => get_books(conf),
        'movies' => get_movies(conf)
    }
    puts ''
end