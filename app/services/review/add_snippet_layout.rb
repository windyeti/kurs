class Services::Review::AddSnippetLayout
  attr_reader :theme_id
  def initialize(review_integration, theme_id)
    @review_integration = review_integration
    @theme_id = theme_id
  end

  def call
    p integration = @review_integration.integration
    p url_domain = Services::Insales::UrlDomain.new(integration).call
    p uri = "#{url_domain}/admin/themes/#{theme_id}/assets.json"

    response = RestClient.get(uri)
    data = JSON.parse(response)
    data.each do |d|
      if d['inner_file_name'] == "footer.liquid"
        @footer_id = d['id']
      end
    end

    uri = "#{url_domain}/admin/themes/#{theme_id}/assets/#{@footer_id}.json"

    resp_get_footer_content = RestClient.get(uri)
    data = JSON.parse(resp_get_footer_content)
    footer_content = data['content']
    new_footer_content = footer_content+' <span class="k-kurs-review">{% include "k-kurs-review" %}</span>'

    data = "<asset><content><![CDATA[ #{new_footer_content} ]]></content></asset>"
    uri_new_footer = "#{url_domain}/admin/themes/#{theme_id}/assets/#{@footer_id}.xml"
    RestClient.put uri_new_footer, data, :accept => :xml, :content_type => "application/xml"
  end
end

