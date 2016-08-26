module ApplicationHelper
  def full_title(page_title='')
    page_base = "Ehsan Akbari\'s Personal Website"
    if page_title.empty?
      page_base
    else
      page_title+" | "+page_base
    end
  end
end
