class Services::Review::SetupInsales
  def initialize(review_integration)
    @review_integration = review_integration
    @integration = @review_integration.integration
    @theme_id = Services::Insales::GetTheme.new(@integration).call
    @url_domain = Services::Insales::UrlDomain.new(@integration).call
  end

  def call
    add_snippet
    add_snippet_layout
    add_template_page
    # Services::Review::AddPage.new(@review_integration, theme_id).call
  end


  private

  def add_snippet
    p uri = "#{@url_domain}/admin/themes/#{@theme_id}/assets.xml"

    data = '<?xml version="1.0" encoding="UTF-8"?><asset><name>k-kurs-review.liquid</name>
    <content><![CDATA[

    <style>
      .header__review-page__link { margin-right: 10px;}
      .header__review-page__link a { text-decoration: none; }
    </style>

    <script type="text/javascript">
      $(document).ready(function(){
        $(".header__review-page__link").prependTo($(".header-menu-right"))
      })
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

  def add_snippet_layout
    p uri = "#{@url_domain}/admin/themes/#{@theme_id}/assets.json"

    response = RestClient.get(uri)
    data = JSON.parse(response)
    data.each do |d|
      if d['inner_file_name'] == "footer.liquid"
        p @footer_id = d['id']
      end
    end

    uri = "#{@url_domain}/admin/themes/#{@theme_id}/assets/#{@footer_id}.json"

    resp_get_footer_content = RestClient.get(uri)
    data = JSON.parse(resp_get_footer_content)
    footer_content = data['content']
    new_footer_content = footer_content+' <span class="k-kurs-review">{% include "k-kurs-review" %}</span>'

    data = "<asset><content><![CDATA[ #{new_footer_content} ]]></content></asset>"
    uri_new_footer = "#{@url_domain}/admin/themes/#{@theme_id}/assets/#{@footer_id}.xml"
    RestClient.put uri_new_footer, data, :accept => :xml, :content_type => "application/xml"
  end

  def add_template_page

    uri = "#{@url_domain}/admin/themes/#{@theme_id}/assets.xml"
    # TODO 167.172.160.127 заменить на имя домена
    data = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><asset><name>page.reviews.liquid</name>
  <content><![CDATA[

<div class=\"container page-headding-wrapper\">
  <h1 class=\"page-headding\">Отзывы на товары</h1>
</div>
<script type=\"text/javascript\">

    $(document).ready(function(){
      var url = \"https://irbandtest.ru/integrations/#{@integration.id}/review_integrations/get_reviews\"
      var host = \"{{account.subdomain}}.myinsales.ru\";
      $.ajax({
        \"url\": url,
        \"async\": false,
        \"data\": { host: host },
        \"dataType\": \"json\"
      }).done(function( data ) {

console.log(\"ответ из приложения на запрос Отзывов\", data)

            var reviewsHtml = \"\";
            reviewsHtml += \'<div class=\"reviews\"><div class=\"row is-grid\">\';
            $.each(data.reviews, function(i,review){
              reviewsHtml += \'<div class=\"cell-4 cell-6-sm cell-12-xs\"> Здесь будут отзывы</div>\'; //двойные кавычки оставил стандартно, а экранировал одинарные и так в каждой строке дальше
            });
          reviewsHtml += \'</div></div>\';
          $(\".js-reviews-wrapper\").html(reviewsHtml);
    });
    });
    </script>

    <div class=\"js-reviews-wrapper\"></div>

  ]]></content><type>Asset::Template</type></asset>"

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
