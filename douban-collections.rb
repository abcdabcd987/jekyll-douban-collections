require "rubygems"
require "json"
require "net/http"
require "uri"
require 'nokogiri'
require 'open-uri'

def get_books(username)
    puts 'douban-collections: getting books...'
    books = []

    uri = URI.parse("https://api.douban.com/v2/book/user/#{username}/collections")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    http.use_ssl = true
    response = http.request(request)
    if response.code == "200"
        result = JSON.parse(response.body)
        result['collections'].each do |doc|
            books.push doc
            #puts doc.inspect
            #puts "#{doc['updated']} #{doc['status']} #{doc['book_id']} #{doc['book']['title']} #{doc['book']['author']}"
        end
    else
        puts "ERROR!!!"
    end

    books
end

def get_movies(username)
    puts 'douban-collections: getting movies...'
    movies = []

    uri = "http://movie.douban.com/people/#{username}/collect?sort=time&start=0&filter=all&mode=grid&tags_sort=count"
    while not uri.empty? do
        doc = Nokogiri::HTML(open(uri))
        doc.css('.item .info').each do |doc_wrap|
            m = {}
            doc_title = doc_wrap.css('.title em').first
            doc_movieid = doc_wrap.css('.title a').first
            doc_date = doc_wrap.css('.date').first
            titles = doc_title.content.split(' / ')
            if titles.size == 2
                m['title'] = titles[0].strip
                m['title_original'] = titles[1].strip
            else
                m['title'] = doc_title.content.strip
                m['title_original'] = m['title']
            end
            m['date'] = doc_date.content[/\d{4}-\d{2}-\d{2}/]
            m['movie_id'] = doc_movieid['href'][/\d+/]
            movies.push m
        end
        doc_next = doc.css('.paginator .next a')
        uri = doc_next.size > 0 ? doc_next.first['href'] : ''
    end

    movies
end

Jekyll::Hooks.register :site, :pre_render do |site, vars|
    puts ''
    conf = site.config['douban-collections']
    vars['douban'] = {
        'books'  => get_books(conf['username']),
        'movies' => get_movies(conf['username'])
    }
    puts ''
end