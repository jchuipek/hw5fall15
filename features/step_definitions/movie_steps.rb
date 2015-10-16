# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end
 
 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end
 
# Add a declarative step here for populating the DB with movies.
 Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
 end

# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these

 When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  visit movies_path
  page.uncheck("ratings_G")
  page.uncheck("ratings_PG")
  page.uncheck("ratings_PG-13")
  page.uncheck("ratings_NC-17")
  page.uncheck("ratings_R")
  arg1.split(", ").each do |i|
    page.check("ratings_#{i}")
  end
  click_button('Refresh')
 end

 Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  rows = page.all("table#movies tbody tr td[2]").map {|t| t.text}
  argument = arg1.split(", ")
  result = false
  valid = true
  rows.each do|i|
    argument.each do|j|
        if(j == i)
            result = true
        end
    end
    if(result != true)
        valid = false
    end
    result = false
  end
   expect(valid).to be_truthy
 end

 Then /^I should see all of the movies$/ do
    rows = page.all("table#movies tbody tr td[1]").map {|t| t.text}
    result = false
    
    if(rows.size == Movie.all.size)
        result = true
    end
    expect(result).to be_truthy
 end


When(/^I click "(.*?)"$/) do |arg1|
  visit movies_path
  click_link('Release Date')
end

Then(/^I should see the movie "(.*?)" before "(.*?)"$/) do |arg1, arg2|
    date = page.all("table#movies tbody tr td[1]").map {|t| t.text}
    count = 0
    result = true
    @pos1 = 0 
    @pos2 = 0
    @prev = ""
    
    date.each do|i|
        if(i == arg1)
            @pos1 = count
        end
        if(i == arg2)
            @pos2 = count
        end
        count = count + 1
    end
    if(@pos1 > @pos2)
        result = false
    else
        result = true
    end
    expect(result).to be_truthy
end

When(/^I click the link "(.*?)"$/) do |arg1|
  visit movies_path
  click_link('Movie Title')
end

Then(/^I should see "(.*?)" before "(.*?)"$/) do |arg1, arg2|
    title = page.all("table#movies tbody tr td[1]").map {|t| t.text}
    count = 0
    result = true
    @position1 = 0 
    @position2 = 0
    @previous = ""
    
    title.each do|i|
        if(i == arg1)
            @position1 = count
        end
        if(i == arg2)
            @position2 = count
        end
        count = count + 1
    end
    if(@position1 > @position2)
        result = false
    else
        result = true
    end
    expect(result).to be_truthy
end



