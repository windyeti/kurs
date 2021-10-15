class Services::Review::SetupInsales
  def initialize(review_integration)
    @review_integration = review_integration
  end

  def call
    # therme_id = test_12345678
    therme_id = Services::Insales::GetTheme.new(@review_integration).call
    Services::Review::AddSnippet.new(@review_integration, therme_id).call
    Services::Review::AddSnippetLayout.new(@review_integration, therme_id).call
    Services::Review::AddPage.new(@review_integration, therme_id).call
  end
end
