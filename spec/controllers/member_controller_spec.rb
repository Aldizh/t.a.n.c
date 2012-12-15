require "spec_helper"

describe MemberController do

    it "should sign up user" do
       get :signup, {:email => "oski@berkeley.edu"}
       @member = mock('Member')
       Member.stub!(:find_by_email).with("oski@berkeley.edu").and_return(@member)
    end

    it "should confirm account" do
        get :confirm_account, {:email => "oski@berkeley.edu"}
    end

    it "Should set up the account for members" do
        mock = mock('Member')
        mock.stub!(:commit).and_return("Continue")
        mock.stub!(:user_email).and_return("oski@berkeley.edu")
     end

     it "should login" do
        get :profile, {:email => "oski@berkeley.edu", :password => "1234"}
     end

     it "should go to the login" do
        get :login, {:email => "oski@berkeley.edu", :password => "1234"}
        controller.stub!(:find_user_by_email).with("oski@berkeley.edu")
        response.should be_successful
     end

     it "should not login with wrong action" do
        mock = mock('Member')
        mock.stub!(:commit).and_return("Continue")
        mock.stub!(:find_by_email).with("myemail@gmail.com").should_not == mock
        mock.stub!(:user_exists_valid).with('false')
     end

     describe "for those with proper email and code" do
       it "should find members by emails" do
          Member.stub!(:find_by_email).with("oski@berkeley.edu").and_return(@member)
       end
     end

     describe "setting up account without signing up first" do
        it "should error out" do 
           @member = Member.create!(:first => "Steven", :last => "Choi", :email => "stevn1202@gmail.com")
           get :account_setup_member, {:commit => 'Continue'}
           flash[:error].should == "You need to sign up or login first!"
        end
     end
     
     
     describe "signing up for the first time" do
        before(:each) do 
              @first_name = "Ki Lim"
	      @last_name = "Choi"
              @email = "stevn1202@gmail.com"
              @already_a_member = "Yes"
              @year_of_birth = "1991"
              @gender = "male"
              @country_of_birth = "South Korea"
              @occupation = "student"
              @special_skills = "Jumping Jacks"
              @number_of_children = 0
              @city = "Berkeley"
              @address1 = "2283 Hearst Avenue"
              @zip = "94709" 
              @telephone = "2137008466"
              @member_active = false
        end
  
        it "should sign up for the first time" do 
           @member = Member.create!(:email => @email)
           get :signup, {:commit => 'Continue'}
           response.should be_successful
        end
         
        #it "should create an account" do
           #@member = Member.find_by_email(@email) 
           #@member = Member.create!(:first => @first_name, :last => @last_name, :email => @email, :already_a_member => @already_a_member,
                                    #:year_of_birth => @year_of_birth, :gender => @gender, :occupation => @occupation, :special_skills => @special_skills,
                                    #:number_of_children => @number_of_children, :member_active => @member_active, :city => @city, 
                                    #:address1 => @address1, :zip => @zip, :telephone => @telephone)
           #get :account_setup_member, {:commit => 'Continue'}
	   #flash[:error].should == ""
        #end
     end
end
