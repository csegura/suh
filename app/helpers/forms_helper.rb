module FormsHelper

  #  Generate the submit or cancel button in a div called actions
  #  submit_or_cancel f, new_path, :class => :full
  #  submit_or_cancel f, 'new_comment_form'
  #  auto check if form is remote then call to app_hided to hide the div on cancel
  #  when remote use link_to_function
  def submit_or_cancel(form, path, options = {})
    style = options.delete(:class)
    remote = form.options[:html][:remote]
    path = "app_hided('#{path}')" if remote
    render 'shared/submit_or_cancel', :f => form, :path => path, :style => style, :remote => remote
  end

  def select_access_id(form)
    if is_owner?
      render "shared/select_access", :f => form
    end
  end

  def select_permissions(form)
    if is_owner?
      render "shared/select_permissions", :f => form
    end
  end

  # used in rjs
  def ejs(code)
    escape_javascript(code)
  end

  # in-place editor of field
  # editable_field category, :name
  def editable_field(model, attribute)
    content_tag :span, :class => :editable, :id => "editable#{model.class}_#{model.id}" do
      model.send(attribute)
    end
  end

  def link_to_delete(url, text='')
      link_to text,
              url,
              :method => :delete,
              :confirm => t('label.sure'),
              :remote => true,
              :class => :delete
  end

  def link_to_delete_auth(subject, url, text='')
    not_in_trash = subject.respond_to?(:in_trash?) ? !subject.in_trash? : true
    if not_in_trash && can_delete?(subject)
      link_to_delete url, text
    end
  end

  def can_delete?(subject)
    if subject.access.id == current_access.id
      return true
    end
    if current_access.is_owner?
      return true
    end
    false
  end

end