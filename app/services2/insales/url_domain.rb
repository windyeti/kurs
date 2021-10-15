class Services::Insales::UrlDomain
  def initialize(integration)
    @integration = integration
  end

  def call
    if @integration.inskey.present?
      "http://#{@integration.inskey}:#{@integration.password}@#{@integration.subdomain}"
    else
      "http://k-kurs:#{@integration.password}@#{@integration.subdomain}"
    end
  end
end
