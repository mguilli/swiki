# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create free account user
freeuser = User.new(
  name: 'Free User',
  email: 'freeuser@example.org',
  password: 'password'
)
freeuser.skip_confirmation!
freeuser.save

# Create paid account user
paiduser = User.new(
  name: 'Paid User',
  email: 'paiduser@example.org',
  password: 'password',
  premium_user: true
)
paiduser.skip_confirmation!
paiduser.save

# Create wiki articles and associated collab entries
Wiki.create_wiki(freeuser, "Dog Poop")
Wiki.create_wiki(freeuser, "Cat")
Wiki.create_wiki(paiduser, "Rat")
Wiki.create_wiki(paiduser, "Monkey", false)

#Create collaboration on Monkey article
Collab.create(
  owner: false,
  user_id: freeuser.id,
  wiki_id: Wiki.last.id
)

puts "Seed finished"
puts "#{User.count} users created."
puts "#{Wiki.count} wikis created."
puts "#{Collab.count} collaborations created."

public 

