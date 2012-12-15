class Member < ActiveRecord::Base
  attr_accessible :email, :password, :status, :member_type, :first, :last, :admin, :telephone, :address1, :address2, :city, :zip, :gender, :year_of_birth, :country_of_birth, :occupation, :number_of_children, :payment_method, :state
  validates :email, presence: true, uniqueness: true, format: {with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i}
  
  def self.random_password
    (0...8).map{65.+(rand(26)).chr}.join
  end

  def send_reset_password
    self.password_reset_sent_at = Time.zone.now
    self.password = Member.random_password
    save!
    IndividualMailer.reset_password(self).deliver()
  end     
 
  def send_activation_email
    email = IndividualMailer.activation_notification(self)
    email.deliver()
  end
  
  def confirm(code)
    if code == self.password
      update_attribute('confirmed', true)
      return true
    else
      return false
    end
  end

  def authenticate(password)
    return self.password == password
  end

  def update_password(password, verify)
    if password == verify and password != ""
      self.password = password
      self.save
      return true
    else
      return false
    end
  end

  def user_data
    data = {:type => self.member_type,
      :email => self.email,
      :first => self.first,
      :last => self.last,
      :status => self.status,
      :address1 => self.address1,
      :address2 => self.address2,
      :city => self.city,
      :state => self.state,
      :zip => self.zip,
      :telephone => self.telephone,
      :year_of_birth => self.year_of_birth,
      :country_of_birth => self.country_of_birth,
      :occupation => self.occupation,
      :gender => self.gender,
      :number_of_children => self.number_of_children,
      :id => self.id 
    }
    return data
  end

  def validate(params)
      if params["address-line-2"] and params["address-line-2"] == ""
         params.delete("address-line-2")
      end
      if params["first"] and params["first"] =~ /[A-Za-z]+/; true;
      if params["last"] and params["last"] =~ /[A-Za-z]+/; true;
      if params["telephone"] and params["telephone"] =~ /\d{1,10}|[-]/; true;
      if params["address1"] and params["address1"] =~ /\d|[-]|[A-Za-z]+|\s|./; true;
      if params["address2"] and params["address2"] =~ /\d|[-]|[A-Za-z]+|\s|./; true;
      if params["city"] and params["city"] =~ /[A-Za-z]+/; true;
      if params["state"] and params["state"] =~ /[A-Za-z]{2}/; true;
      if params["zip"] and params["zip"] =~ /\d{5}/; true;
      if params["gender"]; true;
      if params["member"]["year_of_birth"] and params["member"]["year_of_birth"] =~ /\d{4}/; true;
      if params["member"]["country_of_birth"] and params["member"]["country_of_birth"] =~ /[A-Za-z]+/; true;
      if params["number_of_children"]; true;
      if params["occupation"]; true;
      if params["Status"]; true;
      if params["member_type"]; true;
      else return false; end;
      end
      end
      end
      end
      end
      end
      end
      end
      end
      end
      end
      end
      end
      end
  end


  def validate_and_update(params)
      if params["address-line-2"] and params["address-line-2"] == ""
	params.delete("address-line-2")
      end
      if params["first-name"] and params["first-name"] =~ /[A-Za-z]+/; self.first = params["first-name"];
      else return false; end;
      if params["last-name"] and params["last-name"] =~ /[A-Za-z]+/; self.last = params["last-name"];
      else return false; end;
      if params["address-line-1"] and params["address-line-1"] =~ /\d|[-]|[A-Za-z]+|\s|./; self.address1 = params["address-line-1"];
      else return false; end;
      if params["address-line-2"] and params["address-line-2"] =~ /\d|[-]|[A-Za-z]+|\s|./; self.address2 = params["address-line-2"]; end;
      if params["already_a_member"]; self.already_a_member = params["already_a_member"]; end;
      if params["number_of_children"]; self.number_of_children = params["number_of_children"]; 
      else return false; end;
      if params["city"] and params["city"] =~ /[A-Za-z]+/; self.city = params["city"];
      else return false; end;
      if params["zip"] and params["zip"] =~ /\d{5}/; self.zip = params["zip"];
      else return false; end;
      if params["state"] and params["state"] =~ /[A-Za-z]{2}/; self.state = params["state"];
      else return false; end;
      if params["telephone"] and params["telephone"] =~ /\d{1,10}|[-]/; self.telephone = params["telephone"];
      else return false; end;
      if params["year_of_birth"] and params["year_of_birth"] =~ /\d{4}/; self.year_of_birth = params["year_of_birth"]
      else return false; end;
      if params["country_of_birth"] and params["country_of_birth"] =~ /[A-Za-z]+/; self.country_of_birth = params["country_of_birth"]
      elsif params["country_of_birth"] == ""
        return true
      elsif params["country_of_birth"] !=~ /[A-Za-z]+/
        return false
      end
      if params["occupation"]; self.occupation = params["occupation"];
      else return false; end;
      if params["gender"]; self.gender = params["gender"];
      else return false; end;
      if params["special_skills"] and params["special_skills"] =~ /[A-Za-z]+/
         self.special_skills = params["special_skills"]
      elsif params["special_skills"] == ""
         return true
      elsif params["special_skills"] !=~ /[A-Za-z]+/
         return false
      end
      if self.member_active == true; self.member_active = true; else self.member_active = false; end;
      self.save
      return true
  end
  
  def validate_and_update_non_member(params)
    if params["address-line-2"] and params["address-line-2"] == ""
      	params.delete("address-line-2")
    end
    if params["first-name"] and params["first-name"] =~ /[A-Za-z]+/; self.first = params["first-name"];
    else return false; end;
    if params["last-name"] and params["last-name"] =~ /[A-Za-z]+/; self.last = params["last-name"];
    else return false; end;
    if params["address-line-1"] and params["address-line-1"] =~ /\d|[-]|[A-Za-z]+|\s|./; self.address1 = params["address-line-1"]; end;
    if params["address-line-2"] and params["address-line-2"] =~ /\d|[-]|[A-Za-z]+|\s|./; self.address2 = params["address-line-2"]; end;
    if params["city"] =~ /[A-Za-z]+/; self.city = params["city"] rescue nil; end;
    if params["zip"] =~ /\d{5}/; self.zip = params["zip"] rescue nil; end;
    if params["state"] =~ /[A-Za-z]{2}/; self.state = params["state"] rescue nil; end;
    if params["telephone"] and params["telephone"] =~ /\d{1,10}|[-]/; self.telephone = params["telephone"] rescue nil; end;
    if self.non_member_active == true; self.non_member_active = true; else self.non_member_active = false; end;
    self.save
    return true
  end
end
