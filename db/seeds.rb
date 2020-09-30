# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'json'

puts "Deleting all states"

State.delete_all

URL = "https://servicodados.ibge.gov.br/api/v1/localidades/estados"

states = JSON.parse(open(URL).read)
states.each do |object|
  new_state = State.create!(name: object["nome"])
  puts "Creating #{new_state.name}"
end

# puts "Deleting all cities"

# City.delete_all

# URL2 = "https://servicodados.ibge.gov.br/api/v1/localidades/municipios"

# cities = JSON.parse(open(URL2).read)
# cities.each do |object|
#   uf = object["microrregião"]["mesorregiao"]["UF"]["nome"]
#   new_city = City.create!(name: object["nome"], state_id: State.where(name: uf)
#   puts "Creating #{new_city.name}"
# end