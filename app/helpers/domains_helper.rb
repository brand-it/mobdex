module DomainsHelper
  def favicon_uri(domain_url)
    domain_url + "favicon.ico"
  end
  
  def http_code_to_color(http_code)
    if http_code == 200
     content_tag(:span, http_code, :style => "color: green;")
    else
      content_tag(:span, http_code, :style => "color: red;")
    end
  end
end