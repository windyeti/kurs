class Services::Insales::GetTheme
  attr_reader :resource

  def initialize(integration)
    @integration = integration
  end

  def call
    url_domain = Services::Insales::UrlDomain.new(@integration).call

    uri = "#{url_domain}/admin/themes.json"
    theme_id = 0
    response = RestClient.get(uri)
    data = JSON.parse(response)
    data.each do |d|
      if d['is_published'] == true
        theme_id = d['id']
      end
    end
    theme_id
  end
end
