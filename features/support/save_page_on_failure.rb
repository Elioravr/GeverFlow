After do |scenario|
  if scenario.failed?
    image_file = '/tmp/poltergeist.png'
    page.driver.render(image_file)
    Launchy.open(image_file)
    save_and_open_page
    #page.save_page
  end
end
