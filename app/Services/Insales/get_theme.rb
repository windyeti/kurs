class Services::Insales::GetTheme
  def initialize(resource)
    @resource = resource
  end

  def call
    integration = @resource.integration
    url_domain = Services::Insales::UrlDomain.new(integration).call

    uri = "#{url_domain}/admin/themes.json"

    response = RestClient.get(uri)
    data = JSON.parse(response)
    data.each do |d|
      if d['is_published'] == true
        @theme_id = d['id']
      end
    end
  end
end
