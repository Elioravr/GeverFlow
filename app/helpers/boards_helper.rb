module BoardsHelper
  def table_header(label, href, column_id)
    content_tag 'th', class: 'main-table-header' do
      @task = Task.new
      content_tag('span', label) +
      content_tag('a', '', class: 'add-button', href: href, 'data-toggle' => 'modal', data: {column_id: column_id})
    end
  end

  def tasks_layout(type, id, group_by_date)
    content_tag 'td', '', class: 'column', id: "#{type}-content", data: { id: id, group_by_date: group_by_date } do
      if group_by_date
        content_tag('div', '', class: 'today-container') do
          content_tag('div', 'Today', class: 'task-filter-title') +
          content_tag('div', '', class: 'task-filter-content')
        end +
        content_tag('div', '', class: 'yesterday-container') do
          content_tag('div', 'Yesterday', class: 'task-filter-title') +
          content_tag('div', '', class: 'task-filter-content')
        end +
        content_tag('div', '', class: 'last_week-container') do
          content_tag('div', 'Last Week', class: 'task-filter-title') +
          content_tag('div', '', class: 'task-filter-content')
        end +
        content_tag('div', '', class: 'last_month-container') do
          content_tag('div', 'Last Month', class: 'task-filter-title') +
          content_tag('div', '', class: 'task-filter-content')
        end +
        content_tag('div', '', class: 'before-container') do
          content_tag('div', 'Before', class: 'task-filter-title') +
          content_tag('div', '', class: 'task-filter-content')
        end
      end
    end
  end
end
