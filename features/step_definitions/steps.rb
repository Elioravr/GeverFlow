require 'ruby-debug'

def create_columns(string)
  return [] if string.nil?
  string.split(',').map do |column_name|
    Fabricate(:column, name: column_name.strip)
  end
end

def find_task_by_title(title)
  tasks = page.all('.task-container')
  tasks.each do |task|
    if task.find('h2').find('span').text == title
      return task
    end
  end
  return nil
end

def find_subtask_in_task_by_content(task, content)
  subtasks = task.all('li.subtask')
  subtasks.each do |subtask|
    if subtask.find('span').text == content
      return subtask
    end
  end
  return nil
end

Given /^the following boards:$/ do |table|
  Task.destroy_all
  Board.destroy_all
  Column.destroy_all
  table.hashes.each do |board|
    board['columns'] = create_columns(board['columns'])
    Fabricate(:board, board)
  end
end

Given /^the following tasks:$/ do |table|
  table.hashes.each do |task|
    column_name = task.delete('column')
    task['column_id'] = Column.find_by_name!(column_name).id
    Fabricate(:task, task)
    #t = Task.create!(task)
  end
end

Given /^the following subtasks:$/ do |table|
  table.hashes.each do |subtask|
    task_title = subtask.delete('task')
    subtask['task_id'] = Task.find_by_title(task_title).id
    Fabricate(:subtask, subtask)
  end
end

Given /^the task list page of "(.*?)"$/ do |board|
  visit board_path(Board.find_by_name(board))
end

When /^I'm within the task "(.*?)"$/ do |task_title|
  @container = find_task_by_title(task_title)
end

When /^I'm within the subtask "(.*?)"$/ do |subtask_content|
  @container = find_subtask_in_task_by_content(@container, subtask_content)
end

When /^I click on "(.*?)"$/ do |button|
  try_within { click_on button }
end

When /^I fill in "(.*?)" with "(.*?)"$/ do |field, value|
  try_within { fill_in field, with: value }
end

module WithinHelper
  def try_within
    if @container
      within @container do
        yield
      end
    else
      yield
    end
  end
end
World(WithinHelper)

Then /^the database has a subtask "(.*?)" that is related to "(.*?)"$/ do |subtask_content, task_title|
  task = Task.find_by_title(task_title)
  subtask = Subtask.where(:task_id => task.id, :content => subtask_content)
  subtask.should_not be_nil
end

Then /^the database hasn't a subtask "(.*?)" that is related to "(.*?)"$/ do |subtask_content, task_title|
  task = Task.find_by_title(task_title)
  subtask = Subtask.where(:task_id => task.id, :content => subtask_content)
  subtask.should be_empty
end

Then /^the task "(.*?)" has a subtask "(.*?)"$/ do |task_title, subtask_content|
  task = find_task_by_title(task_title)
  subtask = find_subtask_in_task_by_content(task, subtask_content)
  subtask.should_not be_nil
end

Then /^the task "(.*?)" hasn't a subtask "(.*?)"$/ do |task_title, subtask_content|
  task = find_task_by_title(task_title)
  subtask = find_subtask_in_task_by_content(task, subtask_content)
  subtask.should be_nil
end

Then /^the "(.*?)" field is blank$/ do |field|
  try_within { find_field(field).value.should be_empty }
end
