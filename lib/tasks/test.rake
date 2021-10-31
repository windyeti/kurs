namespace :p do
  task test: :environment do
    uri = "http://8d8c1bfc2a3ce24ae562bdbc2547abda:0f5bf9c1f62cc99230b8ec4a7fc8f055@demo-themes.myinsales.ru/admin/products/235131503.json"

    RestClient.get( uri, :accept => :json, :content_type => "application/json") do |response, request, result, &block|
      case response.code
      when 200
        pp JSON.parse response.body
      when 422
        puts "error 422"
        puts response
      when 404
        puts 'error 404'
        puts response
      when 503
        sleep 1
        puts 'sleep 1 error 503'
      else
        response.return!(&block)
      end
    end
  end
end
