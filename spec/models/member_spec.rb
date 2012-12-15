require "spec_helper"
require 'factory_girl'
describe Member do
   it "When user signs up, a new user should be created" do
       mock = mock('Member')
       mock.stub!(:signup).and_return('true')
       mock.stub!(:confirm).with(:code => '1234', :password =>'1234').and_return('true')
   end
   it "should find the user by email" do
	mock = mock('Member')
	mock.stub!(:find_by_email).with(:email => "oski@berkeley.edu").and_return('true')
   end
end
