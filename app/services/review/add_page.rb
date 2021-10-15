class Services::Review::AddPage
  def initialize(review_integration, therme_id)
    @review_integration = review_integration
    @therme_id = therme_id
  end

  def call
    integration = @review_integration.integration
    url_domain = Services::Insales::UrlDomain.new(integration).call
    uri = "#{url_domain}/admin/themes/#{@theme_id}/assets.xml"

    data = '<?xml version="1.0" encoding="UTF-8"?><asset><name>page.reviews.liquid</name>
  <content><![CDATA[

<div class="container page-headding-wrapper">
  <h1 class="page-headding">Избранные товары</h1>
</div>
<script type="text/javascript">

    $(document).ready(function(){
      var url = "https://4444444.444.444/review_integrations/get_reviews"
      var host = "{{account.subdomain}}.myinsales.ru";
      $.ajax({
        "url": url,
        "async": false,
        "data": { host: host },
        "dataType": "json"
      }).done(function( data ) {

console.log("ответ из приложения на запрос Отзывов", data)

            var reviewsHtml = " ";
            reviewsHtml += \'<div class="reviews"><div class="row is-grid">\';
            $.each(data.reviews, function(i,review){
              reviewsHtml += \'<div class="cell-4 cell-6-sm cell-12-xs"> Здесь будут отзывы\'; //двойные кавычки оставил стандартно, а экранировал одинарные и так в каждой строке дальше
            });
          reviewsHtml += \'</div></div>\';
          $(".js-reviews-wrapper").html(reviewsHtml);
    });
    </script>

    <div class="js-reviews-wrapper"></div>

  ]]></content><type>Asset::Template</type></asset>'

    # response = RestClient.post url, data, :accept => :xml, :content_type => "application/xml"
    RestClient.post( uri, data, {:content_type => 'application/xml', accept: :xml}) do |response, request, result, &block|
      puts response.code
      case response.code
      when 200
        puts 'Файл с именем page.reviews.liquid - сохранили'
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
