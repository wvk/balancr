module ApplicationHelper

  def m(float)
    sprintf('%.2f€', float).sub('.', ',')
  end

  def error_message
    if flash[:error]
      content_tag :p, flash[:error], :id => 'error'
    end
  end

  def notice_message
    if flash[:notice]
      content_tag :p, flash[:notice], :id => 'notice'
    end
  end

  def bottom_nav_link(name, url, options={})
    content_for :bottom_nav do
      link_to name, url, options.merge(:class => 'bottom-link')
    end
  end
end
