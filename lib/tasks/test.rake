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

  task asset: :environment do
    url_theme_id = "http://8d8c1bfc2a3ce24ae562bdbc2547abda:0f5bf9c1f62cc99230b8ec4a7fc8f055@demo-themes.myinsales.ru/admin/themes.json"

    theme_id = 0
    response = RestClient.get(url_theme_id)
    data = JSON.parse(response)
    data.each do |d|
      if d['is_published'] == true
        theme_id = d['id']
      end
    end

    url_assets = "http://8d8c1bfc2a3ce24ae562bdbc2547abda:0f5bf9c1f62cc99230b8ec4a7fc8f055@demo-themes.myinsales.ru/admin/themes/#{theme_id}/assets.json"
    response_assets = RestClient.get(url_assets)
    assets = JSON.parse(response_assets)

    assets.each do |asset|
      if asset['inner_file_name'] == "footer.liquid"
        asset_id = asset['id']
        response_layout = RestClient.get("http://8d8c1bfc2a3ce24ae562bdbc2547abda:0f5bf9c1f62cc99230b8ec4a7fc8f055@demo-themes.myinsales.ru/admin/themes/#{theme_id}/assets/#{asset_id}.json")
        pp layout = JSON.parse(response_layout)

        new_content = layout['content'].gsub('<span class="k-kurs-review">{% include "k-kurs-review" %}</span>','')
        # new_layout = '<asset><content><![CDATA[ '+new_content+' ]]></content></asset>'
        # url_layout_xml ="#{url_theme}/assets/#{asset_id}.xml"
        # RestClient.put(url_layout_xml, new_layout, :accept => :xml, :content_type => "application/xml")
      end
    end

  end
end
