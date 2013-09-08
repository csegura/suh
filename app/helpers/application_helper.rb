module ApplicationHelper

  # dirty tabs
  def link_tab(text, url, opts={})
    active = false
    start = opts.delete(:start)
    id = opts.delete(:id)

    if request.fullpath.length == url.length && request.fullpath == url
      active = true
    elsif start && url.length > 1 && request.fullpath.start_with?(url)
      active = true
    end

    opts_li = {}
    opts_li.merge!(:class => :right) if opts.delete(:right)
    opts_li.merge!(:id => id) if id

    if active
      opts.merge! :class => :active
    end

    #Rails.logger.info "#{request.fullpath} #{url} #{text} #{url.length} #{request.fullpath.length}"
    link = link_to text, url, opts

    html = content_tag :li, link, opts_li
    html.html_safe
  end

  def link_back path
    content_tag :p do
      link_to "\u2190 #{t('action.back')}", path, :class => :back
    end
  end


  # Users can upload their avatar, and if it's missing we're going to use
  # gravatar. For leads and contacts we always use gravatars.
  #----------------------------------------------------------------------------
  def avatar_for(model, args = {})
    args = {:class => 'avatar', :size => '48x48'}.merge(args)
    if model.avatar && model.avatar.has_image?
      image_tag(model.avatar.image.url(Avatar.styles[args[:size]]), args)
    elsif model.respond_to?(:email)
      gravatar_image_tag(model.email, {:gravatar => {:default => default_avatar_url}}.merge(args))
    else
      image_tag("avatar.jpg", args)
    end
  end

  # Gravatar helper that adds default CSS class and image URL.
  #----------------------------------------------------------------------------
  def gravatar_for(model, args = {})
    args = {:class => 'gravatar', :gravatar => {:default => default_avatar_url}}.merge(args)
    gravatar_image_tag(model.email, args)
  end


  private

  #----------------------------------------------------------------------------
  def default_avatar_url
    "#{request.protocol + request.host_with_port}" + "/assets/avatar.gif"
  end

  def render_if(action, options={}, locals={}, &block)
    actions = {:new => ["new", "create"],
               :edit => ["edit", "update"]}
    if actions[action].include?(action_name)
      render(options, locals, &block)
    end
  end

  def head_label name, value
    unless value.empty?
      content_tag :p do
        span_label(name)+value
      end
    end
  end

  def span_label name
    name = name.to_s if name.is_a?(Symbol)
    label = I18n.t("label.#{name}")
    "<span class='label'>#{label} :</span>".html_safe
  end

  def title size, value
    tag = %w(h1 h2 h3 h4 h5 h6)[size-1]
    content_tag tag do
      value
    end
  end

  def page_title value
    content_for :title, value
    title 1, value
  end

  def page_head
    content_tag :div, :class => :page_head, :id => :page_head do
      render :partial => "head"
    end
  end

  def page_body value
    content_tag :div, :class => :page_body do
      content_tag(:p, nice_text(value))
    end
  end
end
