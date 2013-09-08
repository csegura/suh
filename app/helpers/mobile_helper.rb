module MobileHelper

  def mobile_page_title header, back_path = :back
    html = "<div data-role='header'>"
    html << mobile_back_button(back_path)
    html << content_tag(:h1, header)
    #html << mobile_link_back(back_path)
    html << "</div>"
    html.html_safe
  end

  def mobile_link_back url
    "<a href='#{url}' data-icon='home' data-iconpos='notext' data-direction='reverse' class='ui-btn-right jmq-home'></a>"
  end

  def mobile_back_button url
    link_to t('action.back'), url, :class => "ui-bt-right", "data-icon" => "back"
  end

  def m_link_to text, url, &block
    link_to text, url, &block
  end

end