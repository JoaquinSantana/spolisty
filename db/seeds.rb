genres = [
  'blues', 'classical', 'country', 'electronic',
  'international', 'jazz',
  'latin', 'pop', 'soul', 'hip-hop',
  'reggae', 'rock', 'comedy'
]

genres.each do |g|
  Genre.create(name: g)
end

25.times do |n|
  User.create!(
    name: Faker::Name.name, 
    email: Faker::Internet.email, 
    image: Faker::Avatar.image("#{n}", '188x188'), 
    about: Faker::Lorem.sentence(8), 
    provider: "spotify", 
    uid: "#{n}", 
    password: 'test1234',
    password_confirmation: 'test1234' )
end