module IssuesHelper

  def issue_status issue
    content_tag :span, :class => issue.open ? :issue_open : :issue_close do
      if issue.open
        I18n.t('issue.open')
      else
        I18n.t('issue.close')
      end
    end
  end

  def link_toogle_trash
    if params[:trash]
      link_to t('label.hide'), params.merge(:trash=>nil), :remote => true
    else
      link_to t('label.show'), params.merge(:trash=>true), :remote => true
    end
  end

end