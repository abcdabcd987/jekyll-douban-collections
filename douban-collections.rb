require "rubygems"
require "json"
require "net/http"
require "uri"

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

Jekyll::Hooks.register :site, :pre_render do |site, vars|
    puts ''
    conf = site.config['douban-collections']
    vars['douban'] = {
        'books' => get_books(conf['username'])
    }
    puts ''
end