Given /^the following members exist:$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |member|
    Member.create!(member)
  end
end

Given /^I logged in as "(.*?)" with password "(.*?)"$/ do |arg1, arg2|
  visit '/member/confirm_account?email=%s&code=%s' % [arg1, arg2]
end

Given /^I fill up all_member_info$/ do 
   e-mail = member.email
   pwd = member.password
   first = member.first_name
   last = member.last_name
   edit = member.Edited
   email.should == "kl_choi@berkeley.edu"
   pwd.should == "secret_pwd"
   first.should == "Tenzin"
   last.should == "choi"
   edit.should == "T"
end

Given /^I clicked the reset link for "(.*?)" with code "(.*?)"$/ do |arg1, arg2|
  visit '/member/reset_email_sent?email=%s&request=%s' % [arg1, arg2]
end

Then /^I should receive a confirmation email$/ do
  email = ActionMailer::Base.deliveries.last
  email.subject.should == "Welcome to TANC"
end 

When /^I visit the admin page again$/ do
    visit '/member/admin'
end

When /^I visit the member edit page again$/ do 
    visit '/member/2/edit'
end
