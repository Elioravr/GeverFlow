module BoardsHelper
  def table_header(label, href)
    content_tag 'th', class: 'main-table-header' do
      content_tag('span', label) +
      content_tag('a', '', class: 'add-button', href: href)
    end
  end

  def tasks_layout(type)
    content_tag 'td' do
      content_tag('div', '', class: "#{type}-content")
    end
  end
end
