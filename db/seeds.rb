# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
members = [{:status => 'Pending', :email => 'azhupani390@berkele.edu', :password => '12345', :member_type => 'member', :confirmed => false, :first => 'Aldi', :last => 'Zhupani', :age => '22' , :address1 => '210 Mars', :city =>  'Pluto', :state => 'CA', :zip => '94705', :telephone => '5105675724'}]
Member.create!(members)
