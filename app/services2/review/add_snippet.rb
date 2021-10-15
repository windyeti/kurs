class Services::Review::AddSnippet
  def initialize(review_integration, therme_id)
    @review_integration = review_integration
    @therme_id = therme_id
  end

  def call
    integration = @review_integration.integration
    url_domain = Services::Insales::UrlDomain.new(integration).call
    uri = "#{url_domain}/admin/themes/"+"#{@theme_id}"+"/assets.xml"

    data = '<?xml version="1.0" encoding="UTF-8"?><asset><name>k-kurs-review.liquid</name>
    <content><![CDATA[

    <style>
      .header__review-page__link { }
      .header__review-page__link a { text-decoration: none; }
    </style>

    <script type="text/javascript">
      $(document).ready(function(){
        $(".header__review-page__link").prependTo($(".header-menu-right")
      }
    </script>

    <span class="header__review-page__link">
        <a href="/page/reviews">
          Отзывы
        </a>
    </span>

  ]]></content><type>Asset::Snippet</type></asset>'

    # response = RestClient.post uri, data, :accept => :xml, :content_type => "application/xml"

    RestClient.post( uri, data, {:content_type => 'application/xml', accept: :xml}) do |response, request, result, &block|
      puts response.code
      case response.code
      when 200
        puts 'Файл с именем k-kurs-review.liquid - сохранили'
        puts response
      when 422
        puts '422'
        puts response
      else
        response.return!(&block)
      end
    end
  end
end
