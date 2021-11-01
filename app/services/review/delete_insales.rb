class Services::Review::DeleteInsales
  def initialize(review_integration)
    @review_integration = review_integration
    @integration = @review_integration.integration
    @theme_id = Services::Insales::GetTheme.new(@integration).call
    @url_domain = Services::Insales::UrlDomain.new(@integration).call
  end

  def call
    delete_files_and_link
  end

  private

  def delete_files_and_link
    url_assets = "#{@url_domain}/admin/themes/#{@theme_id}/assets.json"
    url_theme = "#{@url_domain}/admin/themes/#{@theme_id}"
    response_assets = RestClient.get(url_assets)
    assets = JSON.parse(response_assets)

    assets.each do |asset|
      if asset['inner_file_name'] == "k-kurs-review.liquid" || asset['inner_file_name'] == "page.reviews.liquid"
        asset_id = asset['id']
        RestClient.delete("#{url_theme}/assets/#{asset_id}.json")
      end
      if asset['inner_file_name'] == "footer.liquid"
        asset_id = asset['id']
        response_footer = RestClient.get("#{url_theme}/assets/#{asset_id}.json")
        footer = JSON.parse(response_footer)

        new_content = footer['content'].gsub('<span class="k-kurs-review">{% include "k-kurs-review" %}</span>','')
        new_footer = '<asset><content><![CDATA[ '+new_content+' ]]></content></asset>'
        url_footer_xml ="#{url_theme}/assets/#{asset_id}.xml"
        RestClient.put(url_footer_xml, new_footer, :accept => :xml, :content_type => "application/xml")
      end
    end
  end
end
