Fabricator(:board) do
  user_group
end

Fabricator(:user_group) do
  group_name do
    sequence(:group_name) { |i| "group#{i}" }
  end
end

Fabricator(:task) do
  title do
    sequence(:title) { |i| "task#{i}" }
  end
end

Fabricator(:subtask) do
  content do
    sequence(:content) { |i| "subtask#{i}" }
  end
end

Fabricator(:column) do
  group_by_date false
end
