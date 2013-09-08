require 'hpricot'

module NiceHelper
  # format dates locale, default format :nice
  # see formats in custom.yml (:short, :full, :hour, :month)
  def nice_date(date, format=:nice, options = {})
    if date.nil?
      html = h 'n/a'
    else
      html = l date, :format => format
    end
    if options.include?(:time_ago)
      "#{html} (#{nice_time_ago date})"
    else
      html
    end
  end

  # time ago in words
  def nice_time_ago(date)
    !date.nil? ? time_ago_in_words(date) : 'n/a'
  end

  # number to human size
  def nice_size size
    number_to_human_size size, :precision => 0
  end

  # div for group of dates (summary views)
  def date_group(group, date, colspan='4')
    if group.change? date
      html = content_tag :tr do
        content_tag :td, :class => :sep, :colspan => colspan do
          content_tag :h6 do
            "#{l group.date, :format => :nice_long}"
          end
        end
      end
      #html = "<tr><td class='sep' colspan='4'>"
      ##html << "<span class='g-date'>#{l group.date, :format => :nice_long}</span>"
      #html << "<h6>#{l group.date, :format => :nice_long}</h6>"
      #html << "</td></tr>"
      html.html_safe
    end
  end

  def nice_user(subject)
    if subject.nil?
      return
    end
    if subject.respond_to?(:user)
      subject.user.full_name
    else
      subject.full_name
    end
  end

  def nice_access(access, options = {})
    unless access.nil?
      "#{access.full_name}"
    end
    #company = options.delete(:company)

    #if is_owner? || company
    #  "#{access.user_full_name} (#{access.company_name})"
    #else
    #  "#{access.user_full_name}"
    #end
  end

  def nice_time_in_hours(minutes)
    Time.at(minutes*60).gmtime.strftime('%R')
  end

  def nice_text(text)
    if text
      text.html_safe
    end
  end

  def nice_category(category)
    if category
      category.name.capitalize
    else
      t('category.none')
    end
  end

  def link_to_resource(resource)
    name = t('activerecord.models.'+resource.class.name.downcase)
    link_to(name.capitalize, polymorphic_url(resource))
  end

  # remove html tags and presents only text
  def nice_html_to_text(html_text)
    doc = Hpricot(html_text)
    doc.search("//text()").text
  end
end