class MemberController < ApplicationController
  @member = Member.all
  def show
      if session[:user_email] == "tanc.herokuapp@gmail.com" #replace this email with the email id of admin
          @member = Member.find params[:id]
          @data = @member.user_data 
      else
          flash[:error] = "You're not logged in as an admin."
          redirect_to "/member"
      end
  end

  def edit
    if session[:user_email] == "tanc.herokuapp@gmail.com" #replace this email with the email id of admin
      @member = Member.find params[:id]
      @type = @member.member_type rescue nil
      @status = @member.status rescue nil
      @first = @member.first rescue nil
      @last = @member.last rescue nil
      @address1 = @member.address1 rescue nil
      @address2 = @member.address2 rescue nil
      @city = @member.city rescue nil
      @state = @member.state rescue nil
      @zip = @member.zip rescue nil
      @telephone = @member.telephone rescue nil
      @year_of_birth = @member.year_of_birth rescue nil
      @country_of_birth = @member.country_of_birth rescue nil
      @special_skills = @member.special_skills rescue nil
      @gender = @member.gender rescue nil
      @occupation = @member.occupation rescue nil
      @number_of_children = @member.number_of_children rescue nil
      if params["commit"] == "Update Info"
          if @member and @member.validate(params)
             @member.first = params["first"] rescue nil
             @member.last = params["last"] rescue nil
             @member.gender = params["gender"] rescue nil
             @member.address1 = params["address1"] rescue nil
             @member.address2 = params["address2"] rescue nil
             @member.city = params["city"] rescue nil
             @member.state = params["state"] rescue nil
             @member.zip = params["zip"] rescue nil
             @member.telephone = params["telephone"] rescue nil
             @member.year_of_birth = params["member"]["year_of_birth"] rescue nil
             @member.country_of_birth = params["member"]["country_of_birth"] rescue nil
             @member.status = params["Status"] rescue nil
             @member.number_of_children = params["number_of_children"] rescue nil
             @member.occupation = params["occupation"]
             @member.member_type = params["member_type"]
             @member.save
             redirect_to member_path(@member)
        else
             redirect_to edit_member_path(@member)
             flash[:error] = "Please type in correct format. You have not filled out everything."
        end
    end
    else
      flash[:error] = "You're not logged in as an admin."
      redirect_to "/member"
    end
  end 


  def destroy
    @member = Member.find params[:id] 
    @member.destroy
    flash[:error] = "You successfully deleted #{@member.first}."
    redirect_to "/member/admin"
  end

  def signup
    if email_params_has_value and email_format_is_correct then
        new_member = can_create_new_member
        if new_member
           send_new_member_activation_email(new_member) and redirect_to("/member/thanks")
        else
           flash[:error] = "Your account could not be created because you already signed up."
           redirect_to("/member/signup")
        end
     elsif email_params_has_value and !email_format_is_correct 
	flash.now[:error] = "Please type in correct email address."
    end
  end 
  
  # helper to dry out code: returns true if :email parameter exists
  def email_params_has_value
     if params[:email] then return true
     else return false
     end
  end

  # helper to dry out code: returns true if email is in right format
  def email_format_is_correct
     if params[:email] =~ /^[a-z0-9_\+-]+(\.[a-z0-9_\+-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.([a-z]{2,4})$/
       return true
     else
       return false
     end
  end
    
  def send_new_member_activation_email(new_member)
     new_member.send_activation_email
  end

  def this_user_exists(thisUser)
     if !thisUser.nil?
        return true
     else
        return false
     end
  end

  # helper to create a new member and dry out code + readability
  def can_create_new_member
      user_by_email = Member.find_by_email(params[:email])
      if this_user_exists(user_by_email)
         return false
      else 
         thisUser = Member.create(:email => params[:email], :status => "Pending", :member_type => "non_member", :password => Member.random_password, :admin => false)
         return thisUser
      end
  end
  
  
  def confirm_account
    if email_params_has_value and code_params_has_value then
      @email = params[:email].to_s
      thisUser = Member.find_by_email(@email)
      if this_user_exists_and_temp_pwd_verified(thisUser)
        store_email_in_session(thisUser) and redirect_to("/member/account_setup")
      else
        flash[:error] = "You already created an account with this email. Or We do not accept emails with + sign in between."
        redirect_to("/member/")
      end
    end
  end

  # helper to dry out code: returns true if :code parameter exists
  def code_params_has_value
     if params[:code] then return true
     else return false
     end
  end

  def this_user_exists_and_temp_pwd_verified(aUser)
     if aUser and aUser.confirm(params[:code])
       return true
     else
       return false
     end
  end
  
  def store_email_in_session(aUser)
     session[:user_email] = aUser.email
  end
  
  def reset_password
     if email_params_has_value and member_email?
       if verify_recaptcha
           member = Member.find_by_email(params[:email])
           member.send_reset_password if member
           redirect_to "/member/reset_email_sent"
        else
           flash[:error] = "Your words do not match the ones in the recaptcha image!"
        end
     elsif email_params_has_value and !email_format_is_correct
        flash.now[:error] = "Please type in correct email address."
     elsif email_params_has_value and !member_email? then
        flash.now[:error] = "You haven't signed up with that email! Please go back to the sign up page."
     else
         flash.now[:error] = "Please type in something."
     end
  end
  
  def member_email?
    @member = Member.find_by_email(params[:email])
    if @member.nil?
       return false
    else
       return true
    end
  end

  def reset_email_sent
    if email_params_has_value and member_email?  then
       member = Member.find_by_email(params[:email])
       if member and member.password == params[:request] then
          redirect_to "/member/update_password?email=#{params[:email]}"
       end
    end
  end
    
  def update_password
    @member = Member.find_by_email(params[:email]) rescue nil
    if params[:commit] == "Update Password"
       if verify_recaptcha
         if pwd_strength_check(params[:password])
            if params[:password] == params[:password_confirm]
                @member.update_attributes(:password => params[:password])
                redirect_to "/member/reset_success"
            end
         else
            flash.now[:error] = "Your password should be a combination of numbers and words. They also have to be longer than 5 words."
         end
      else
         flash.now[:error] = "Your words do not match the ones in the recaptcha image!"
      end
    end
  end
  
  def pwd_strength_check(password)
     if password.length > 5 
        if password =~ /^[0-9]+$/
           return false
        elsif password =~ /^[A-za-z]+$/
           return false
        elsif password =~ /^[A-Za-z0-9][A-Za-z0-9]*$/
           return true
        else 
           return false
        end
     else
        return false
     end
  end
  
  def account_setup
    thisUser = Member.find_by_email(session[:user_email]) rescue nil
    if (thisUser.id == 1)
	thisUser.admin = true
    else
	(thisUser.admin = false)
    end
    @email = thisUser.email rescue nil
    if params[:commit] == "Continue"
      if pwd_strength_check(params[:password])
        if thisUser and thisUser.update_password(params[:password], params["confirm-password"])
           if verify_recaptcha
             if params[:membership] == "tibetan" || params[:membership] == "spouseoftibetan" and !thisUser.member_active and !thisUser.non_member_active
                thisUser.member_type = params[:membership]
                thisUser.already_a_member = "No"
                thisUser.save
	        redirect_to("/member/account_setup_member")
             elsif params[:membership] == "non-member" and !thisUser.member_active and !thisUser.non_member_active
                redirect_to("/member/account_setup_non_member")
             elsif thisUser.member_active || thisUser.non_member_active
                flash.now[:error] = "Sorry you can't sign up twice!"
             end
           else
                flash.now[:error] = "Your words do not match the ones in the recaptcha image!"
           end
        else
           flash.now[:error] = "The two passwords do not match"
        end
      else
        flash[:error] = "Your password should be a combination of numbers and words. They also have to be longer than 5 words."
      end
    end
  end

  def account_setup_member
    thisUser = Member.find_by_email(session[:user_email])
    if thisUser
      @first = thisUser.first rescue nil
      @last = thisUser.last rescue nil
      @address1 = thisUser.address1 rescue nil
      @address2 = thisUser.address2 rescue nil
      @city = thisUser.city rescue nil
      @state = thisUser.state rescue nil
      @zip = thisUser.zip rescue nil
      @telephone = thisUser.telephone rescue nil
      @year_of_birth = thisUser.year_of_birth rescue nil
      @country_of_birth = thisUser.country_of_birth rescue nil
      @special_skills = thisUser.special_skills rescue nil
      if params["commit"] == "Continue"
        if thisUser and thisUser.validate_and_update(params)
          if !thisUser.member_active
            thisUser.member_active = true
	    thisUser.save
	    redirect_to("/member/member_payment")
          else
            flash.now[:error] = "You already signed up!"
          end
        else
          @first = thisUser.first rescue nil
          @last = thisUser.last rescue nil
          @address1 = thisUser.address1 rescue nil
          @address2 = thisUser.address2 rescue nil
          @city = thisUser.city rescue nil
          @state = thisUser.state rescue nil
          @zip = thisUser.zip rescue nil
          @telephone = thisUser.telephone rescue nil
          @year_of_birth = thisUser.year_of_birth rescue nil
          @country_of_birth = thisUser.country_of_birth rescue nil
          @special_skills = thisUser.special_skills rescue nil
          flash.now[:error] = "Please enter the correct format/fill in all fields are required."
        end
      end
    else
      flash[:error] = "You need to sign up or login first!"
      redirect_to("/member")
    end
  end

  def account_setup_non_member
    thisUser = Member.find_by_email(session[:user_email])
    if thisUser
      @first = thisUser.first rescue nil
      @last = thisUser.last rescue nil
      @address1 = thisUser.address1 rescue nil
      @address2 = thisUser.address2 rescue nil
      @city = thisUser.city rescue nil
      @state = thisUser.state rescue nil
      @zip = thisUser.zip rescue nil
      @telephone = thisUser.telephone rescue nil
      if params["commit"] == "Submit"
        if thisUser and thisUser.validate_and_update_non_member(params)
          if !thisUser.non_member_active
            thisUser.non_member_active = true
            thisUser.save
            redirect_to("/member/thanks_after_done")
          else
            flash.now[:error] = "You already signed up as a non-member!"
          end
        else
          flash.now[:error] = "Please enter the correct format/fill in the required fields."
        end
      end
    else
      flash[:error] = "You need to sign up or login first!"
      redirect_to("/member")
    end
  end
  
  def edit_member_profile
    thisUser = Member.find_by_email(session[:user_email])
    if thisUser
      @first = thisUser.first rescue nil
      @last = thisUser.last rescue nil
      @address1 = thisUser.address1 rescue nil
      @address2 = thisUser.address2 rescue nil
      @city = thisUser.city rescue nil
      @state = thisUser.state rescue nil
      @zip = thisUser.zip rescue nil
      @telephone = thisUser.telephone rescue nil
      @year_of_birth = thisUser.year_of_birth rescue nil
      @country_of_birth = thisUser.country_of_birth rescue nil
      @special_skills = thisUser.special_skills rescue nil
      @gender = thisUser.gender rescue nil
      @occupation = thisUser.occupation rescue nil
      @number_of_children = thisUser.number_of_children rescue nil
      @already_a_member = thisUser.already_a_member rescue nil
      if params["commit"] == "Continue"  
        if thisUser and thisUser.validate_and_update(params)
           if verify_recaptcha 
             @first = thisUser.first rescue nil
             @last = thisUser.last rescue nil
             @address1 = thisUser.address1 rescue nil
             @address2 = thisUser.address2 rescue nil
             @city = thisUser.city rescue nil
             @state = thisUser.state rescue nil
             @zip = thisUser.zip rescue nil
             @telephone = thisUser.telephone rescue nil
             @year_of_birth = thisUser.year_of_birth rescue nil
             @country_of_birth = thisUser.country_of_birth rescue nil
             @special_skills = thisUser.special_skills rescue nil
             @gender = thisUser.gender rescue nil
             @occupation = thisUser.occupation rescue nil
             @number_of_children = thisUser.number_of_children rescue nil
             @already_a_member = thisUser.already_a_member rescue nil
             thisUser.save
             redirect_to("/member/edit_success")
          else
             flash[:error] = "Your words do not match the ones in the recaptcha image!"
          end
        else
          flash.now[:error] = "Please enter the correct format/fill in all fields are required."
        end
      end
   else
     flash[:error] = "You need to sign up or login first!"
     redirect_to("/member")
   end
 end

  def edit_non_member_profile
    thisUser = Member.find_by_email(session[:user_email])
    if thisUser
      @first = thisUser.first rescue nil
      @last = thisUser.last rescue nil
      @address1 = thisUser.address1 rescue nil
      @address2 = thisUser.address2 rescue nil
      @city = thisUser.city rescue nil
      @state = thisUser.state rescue nil
      @zip = thisUser.zip rescue nil
      @telephone = thisUser.telephone rescue nil
      if params["commit"] == "Submit"
        if thisUser and thisUser.validate_and_update_non_member(params)  
           if verify_recaptcha
             @first = thisUser.first rescue nil
             @last = thisUser.last rescue nil
             @address1 = thisUser.address1 rescue nil
             @address2 = thisUser.address2 rescue nil
             @city = thisUser.city rescue nil
             @state = thisUser.state rescue nil
             @zip = thisUser.zip rescue nil
             @telephone = thisUser.telephone rescue nil
             thisUser.save
             redirect_to("/member/edit_success")
           else
             flash[:error] = "Your words do not match the ones in the recaptcha image!"
           end
        else
           flash.now[:error] = "Please enter the correct format/fill in the required fields."
        end
     end
    else
      flash[:error] = "You need to sign up or login first!"
      redirect_to("/member")
    end
  end

  def login
    if params[:commit] == "Login"
      thisUser = find_user_by_email(params[:email]) rescue nil
      if user_exists_valid(thisUser)
	      session[:user_email] = thisUser.email rescue nil
        redirect_to("/member/profile")
      else
        @email = params[:email]
        flash[:error] = "Your login information is not correct."
        render("index")
      end
    end
  end
  
  def find_user_by_email(email)
    return Member.find_by_email(email)
  end
 
  def user_exists_valid(thisUser)
     return (thisUser and thisUser.authenticate(params[:password]))
  end
  

  def member_payment 
    thisUser = Member.find_by_email(session[:user_email])
    if params["commit"] == "Check or Cash"
       thisUser.payment_method = "Check or Cash"
       thisUser.save
       redirect_to("/member/check_cash_payment")
    elsif params["commit"] == "Online Payment"
       thisUser.payment_method = "Online Payment"
       thisUser.save
       redirect_to("/member/online_payment")
    elsif params["commit"] == "Not Paying!"
       thisUser.payment_method = "Not Paying"
       thisUser.save
       redirect_to("/member/thanks_after_done")
    end
  end
  
  def check_cash_payment
    thisUser = Member.find_by_email(session[:user_email])
    thisUser.payment_method = "Check or Cash"
    if params["commit"] == "Done!"
       redirect_to("/member/thanks_after_done")
    end
  end

  def online_payment 
    thisUser = Member.find_by_email(session[:user_email])
    thisUser.payment_method = "Online Payment"
    if params["commit"] == "Done!"
       redirect_to("/member/thanks_after_done")
    end
  end

  
  def delete
    flash[:error] = "You are successfully logged out!"
    redirect_to("/member")
    session.delete(:user_email)#clear user data from session
  end

  def profile
    thisUser = find_user_by_email(session[:user_email])
    if thisUser
        @admin = true if thisUser.admin
        @user_data = thisUser.user_data
    else
        redirect_to("/member/login")
        flash[:error] = "You are not logged in. Please log in and try again."
    end
  end

  def admin
    this_user = find_user_by_email(session[:user_email])
    if this_user # exists
       if (this_user.admin) != true
          redirect_to("/member/profile") #and
	  #flash[:error] = "You are not an admin so you cannot access the admin page"
       else # if you got here, user is admin
          Member.all.each do |user|
             if user.first
                @member_list << user.user_data rescue nil
             end
          end
       end
       @member = Member.all
       @table_fields = ["id", "name", "email", "gender", "status"]
       sort = params[:sort] || session[:sort]
       if params[:sort] != session[:sort]
         session[:sort] = sort
       end
       if params["commit"] == "logout"
          redirect_to("/member")
	  session.delete(:user_email)#clear user data from session
       end
       if params["commit"] == "Add a new member"
          redirect_to("/member/admin/add_new_member")
       end
       if params["commit"] == "filter"
         showOptions = params["show"]
         if showOptions
           if showOptions.has_key?("full_table")
            @table_fields = "all"
            session[:table_fields] = "all"
           else
            session.delete(:table_fields)
           end
           if not showOptions.has_key?("members")
             @showing_members = false
             session[:showing_members] = false
           else
             @showing_members = true
             session[:showing_members] = true
           end
           if not showOptions.has_key?("non_members")
             @showing_non_members = false
             session[:showing_non_members] = false
           else
             @showing_non_members = true
             session[:showing_non_members] = true
           end
         end
       end

       if session.has_key?(:table_fields)
         @table_fields = session[:table_fields]
       else
         @table_fields = ["id", "name", "email", "gender", "status"]
       end
       if session.has_key?(:showing_members)
         @showing_members = session[:showing_members]
       else
         @showing_members = true
       end
       if session.has_key?(:showing_non_members)
         @showing_non_members = session[:showing_non_members]
       else
         @showing_non_members = true
       end

       if @showing_members and @showing_non_members
         @member = Member.order(sort)
       elsif not @showing_members and @showing_non_members
         @member = Member.where("member_type = ?", "non_member").order(sort)
       elsif @showing_members and not @showing_non_members
         @member = Member.where("member_type != ?", "non_member").order(sort)
       else
         @member = Member.order(sort)
       end
       if params["commit"] == "Delete"
         if params["delete_member"]
           this_user.delete_id = params["delete_member"]
           this_user.save
           redirect_to("member/admin")
         end
         Member.delete(Member.find(this_user.delete_id))
       end

       if params["commit"] == "Edit"
         if params["edit_member"]
           this_user.delete_id = params["edit_member"]
           this_user.save
           redirect_to("/member/edit_member_profile")
         end
       end
   
    else 
	redirect_to("/member")
        flash[:error] = "You are not logged in- please log in first."
    end
  end


  def export
    this_user = find_user_by_email(session[:user_email])
    if this_user and this_user.admin # member is an admin
      filename = 'members.csv'
      ext = File.extname(filename)[1..-1]
      mime = Mime::Type.lookup_by_extension(ext)
      content_type = mime.to_s unless mime.nil?
      @member_list = []
      Member.find(:all).each do |member|
        @member_list << member.user_data
      end
      render "csv_export.csv.erb", :content_type => content_type
    end
  end
end
