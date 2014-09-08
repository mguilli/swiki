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
  role: 'premium'
)
paiduser.skip_confirmation!
paiduser.save

# Create another paid account user
admin = User.new(
  name: 'Admin User',
  email: 'admin@example.org',
  password: 'password',
  role: 'admin'
)
admin.skip_confirmation!
admin.save

# Create wiki articles and associated collab entries
Wiki.create_wiki_seed(freeuser, "Dog Poop")
Wiki.create_wiki_seed(freeuser, "Cat")
Wiki.create_wiki_seed(paiduser, "Rat")
Wiki.create_wiki_seed(paiduser, "Monkey", false)
Wiki.create_wiki_seed(paiduser, "Giraffe", false)
Wiki.create_wiki_seed(admin, "Dolphin", false)
Wiki.create_wiki_seed(admin, "Platypus", false)


#Create collaboration on articles
Collab.create(
  owner: false,
  user_id: freeuser.id,
  wiki_id: 4
)

Collab.create(
  owner: false,
  user_id: freeuser.id,
  wiki_id: 5
)

Collab.create(
  owner: false,
  user_id: paiduser.id,
  wiki_id: 6
)

Collab.create(
  owner: false,
  user_id: freeuser.id,
  wiki_id: 7
)

puts "Seed finished"
puts "#{User.count} users created."
puts "#{Wiki.count} wikis created."
puts "#{Collab.where(owner: false).count} collaborators added."