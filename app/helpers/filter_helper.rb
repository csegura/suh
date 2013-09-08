module FilterHelper

  def link_filter text, values = {}
    default = values.delete(:default)
    link_to_function text, "filter_call(#{values.to_json},this)", :class => (default ? :filter_on : :filter_link)
  end

end