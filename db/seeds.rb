#Task.delete_all
#Task.create!(title: 'Elior', description: 'Avramoviz', column_id: 1)
#Task.create!(title: 'Alon', description: 'Ben-Moshe', column_id: 1)
#Task.create!(title: 'Alex', description: 'Pushchinsky', column_id: 3)
#Task.create!(title: 'Netanel', description: 'Aharon', column_id: 3)
#Task.create!(title: 'Dani', description: 'Sielberstain', column_id: 2)
#Task.create!(title: 'David', description: 'Elentok', column_id: 4)
#Task.create!(title: 'Noy', description: 'Atias', column_id: 1)

User.all.each do |user|
  if user.is_admin == nil
    user.is_admin = false
    user.password = "111111"
    user.password_confirmation = "111111"
    user.save!
    puts "aaaa"
  end
end
