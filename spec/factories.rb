Factory.define :member do |member|
   def send_new_member_activation_email(member)
	true
   end
   member.email "oski@berkeley.edu"
   member.password "1234"
end
