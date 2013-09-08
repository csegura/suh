module ListHelper

  # <% group_by_date(@activities,:created_at).each do |date, activities| %>
  #   <%= group_header_date date %>
  #   <% activities.each do |activity| %>
  #    body
  #   <% end %>
  # <% end %>

  def group_by_date(items, field)
    items.group_by { |item| item.send(field).to_date }
  end

  def group_header_date(date, colspan = 4, format = :nice_long)
    content_tag :tr do
      content_tag :td, :class => :sep, :colspan => colspan do
        content_tag :h6 do
          "#{l date, :format => format}"
        end
      end
    end
  end

  def mobile_group_header_date(date, format = :nice_long)
    "<li data-role='list-divider'>#{l date, :format => format}</li>".html_safe
  end

end