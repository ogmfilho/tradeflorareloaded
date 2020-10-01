require 'open-uri'
require 'json'
require 'faker'
require 'brazilian_documents'

# start ============ STATES ======================
  puts "Deleting all states"
  State.delete_all

  URL = "https://servicodados.ibge.gov.br/api/v1/localidades/estados"

  states = JSON.parse(open(URL).read)
  states.each do |object|
    new_state = State.create!(name: object["nome"])
    puts "Creating #{new_state.name}"
  end
# end   ============ STATES ======================





# start ============ CITIES ======================
  puts "Deleting all cities"
  City.delete_all

  URL2 = "https://servicodados.ibge.gov.br/api/v1/localidades/municipios"
  data = JSON.parse(open(URL2).read).sample(10)
  data.each do |object|
    new_city = City.create!(name: object["nome"], state_id: State.find_by(name: object["microrregiao"]["mesorregiao"]["UF"]["nome"])[:id])
    puts "Creating #{new_city.name}"
  end
# end   ============ CITIES ======================







# start ============ BASINS ======================
  puts "Clearing Basins table"
  Basin.destroy_all

  puts "Seeding Basins table"
  Basin.create!(name: "Amazônica", coordinates: "{}")
  Basin.create!(name: "Atlântico Leste", coordinates: "{}")
  Basin.create!(name: "Atlântico Nordeste Oriental", coordinates: "{}")
  Basin.create!(name: "Atlântico Nordeste Ocidental", coordinates: "{}")
  Basin.create!(name: "Atlântico Sudeste", coordinates: "{}")
  Basin.create!(name: "Atlântico Sul", coordinates: "{}")
  Basin.create!(name: "Paraguai", coordinates: "{}")
  Basin.create!(name: "Paraná", coordinates: "{}")
  Basin.create!(name: "Parnaíba", coordinates: "{}")
  Basin.create!(name: "São Francisco", coordinates: "{}")
  Basin.create!(name: "Tocantins-Araguaia", coordinates: "{}")
  Basin.create!(name: "Uruguai", coordinates: "{}")

  puts "Basins seeded!"
# end   ============ BASINS ======================






# start ============ USERS ======================
  # Usuário Wátila Machado
    1.times do
      attributes = {name: "Wátila Machado",
                   password: "123456",
                   document_number: BRDocuments::CPF.generate,
                   phone_number:Faker::PhoneNumber.phone_number,
                   address: Faker::Address.street_address
                   }
     normalized_name = I18n.transliterate(attributes[:name]).downcase
     attributes[:email]="#{normalized_name.split.first}@mail.com"
     attributes[:city_id] = City.all.sample.id
     new_user = User.create!(attributes)
     puts "Creating #{new_user[:name]}"
    end


  # Usuário Bali Mineradora
    1.times do
      attributes = {name: "Bali Mineradora",
                   password: "123456",
                   document_number: BRDocuments::CNPJ.generate,
                   phone_number:Faker::PhoneNumber.phone_number,
                   address: Faker::Address.street_address
                   }
     normalized_name = I18n.transliterate(attributes[:name]).downcase
     attributes[:email]="#{normalized_name.split.first}@mail.com"
     attributes[:city_id] = City.all.sample.id
     new_user = User.create!(attributes)
     puts "Creating #{new_user[:name]}"
    end


  # Pessoa Física
    5.times do
     attributes = {name: Faker::Name.name,
                   password: "123456",
                   document_number: BRDocuments::CPF.generate,
                   phone_number:Faker::PhoneNumber.phone_number,
                   address: Faker::Address.street_address
                   }
     normalized_name = I18n.transliterate(attributes[:name]).downcase
     attributes[:email]="#{normalized_name.split.first}@mail.com"
     attributes[:city_id] = City.all.sample.id
     new_user = User.create!(attributes)
     puts "Creating #{new_user[:name]}"
    end


  # Pessoa Jurídica
    5.times do
     attributes = {name: Faker::Company.name,
                   password: "123456",
                   document_number: BRDocuments::CNPJ.generate,
                   phone_number:Faker::PhoneNumber.phone_number,
                   address: Faker::Address.street_address
                   }
     normalized_name = I18n.transliterate(attributes[:name]).downcase
     attributes[:email]="#{normalized_name.split.first}@mail.com"
     attributes[:city_id] = City.all.sample.id
     new_user = User.create!(attributes)
     puts "Creating #{new_user[:name]}"
    end


  # Variables for support in other seed operations
    user_watila = User.find_by(name: "Wátila Machado")
    user_bali = User.find_by(name: "Bali Mineradora")

    users_ids = []
    User.all.each do |user|
      users_ids << user[:id]

    users_ids.delete(user_watila[:id])
    users_ids.delete(user_bali[:id])
    end
  puts "Users seeded!"
# end   ============ USERS ======================







# start ============ AREAS ======================

  puts "Clearing Areas table"
  Area.destroy_all

  puts "Seeding Areas table"

 # Support for Area seeding

    area_description_faker = [
      "Uma área rural disponível para reflorestamento",
      "Área para reflorestamento na Bacia #{basin_seed[:name]}",
      "Área para reflorestamento.",
      "Disponibilizo área na Bacia #{basin_seed[:name]}"
    ]

    area_coordinates_faker = [
      { name:"Amazônica", range_lat:(-9.297093..-0.165376), range_long:(-65.171125..-52.210211) },
      { name:"Atlântico Leste", range_lat:(-12.904332..-10.925327), range_long:(-39.934120..-38.771828) },
      { name:"Atlântico Nordeste Oriental", range_lat:(-7.049664..-5.594422), range_long:(-39.119006..-35.858550) },
      { name:"Atlântico Nordeste Ocidental", range_lat:(-5.654485..-3.630362), range_long:(-45.159619..-43.433360) },
      { name:"Atlântico Sudeste", range_lat:(-21.537241..-18.205200), range_long:(-43.217002..-41.295759) },
      { name:"Atlântico Sul", range_lat:(-31.033515..-29.056450), range_long:(-53.250156..-51.883939) },
      { name:"Paraguai", range_lat:(-18.343451..-11.907992), range_long:(-57.096231..-53.901001) },
      { name:"Paraná", range_lat:(-24.945905..-21.582357), range_long:(-53.075268..-48.049063) },
      { name:"Parnaíba", range_lat:(-7.131784..-5.193976), range_long:(-43.213586..-42.593224) },
      { name:"São Francisco", range_lat:(-12.034531..-9.728735), range_long:(-43.421399..-42.119223) },
      { name:"Tocantins-Araguaia", range_lat:(-13.271896..-3.246820), range_long:(-50.530603..-46.122949) },
      { name:"Uruguai", range_lat:(-30.294418..-29.033095), range_long:(-56.032921..-54.474580) },
    ]



  # Area seeds for test user Wátila Machado
    4.times do
      basin_seed = Basin.all.sample

      area_coordinates_faker.select! {|hash| hash[:name] == basin_seed[:name]}
      attributes = {
         description: area_description_faker.sample,
         # coordinates: "{}"
         # extension: 10
         # status: true
         latitude: rand(area_coordinates_faker.first[:range_lat]),
         longitude: rand(area_coordinates_faker.first[:range_long]),
         # address:
         # city_id:
         basin_id: basin_seed[:id],
         user_id: user_watila[:id]
      }
      Area.create!(attributes)
    end



  # Area seeds for aleatory users
    25.times do
      basin_seed = Basin.all.sample

      area_coordinates_faker.select! {|hash| hash[:name] == basin_seed[:name]}
      attributes = {
         description: area_description_faker.sample,
         # coordinates: "{}"
         # extension: 10
         # status: true
         latitude: rand(area_coordinates_faker.first[:range_lat]),
         longitude: rand(area_coordinates_faker.first[:range_long]),
         # address:
         # city_id:
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      Area.create!(attributes)
    end


  # Variables for support in other seed operations

    watila_areas = Area.where(user_id: user_watila[:id])

    areas_ids = []
    Area.all.each do |area|
      areas_ids << area[:id]
    end


  puts "Areas seeded!"
# end   ============ AREAS ======================








# start ============ TRADES ======================
puts "Clearing Trades table"
Trade.destroy_all

puts "Seeding Trades table"

  trade_status_options = ['Proposta', 'Visualizada', 'Aceita', 'Recusada', 'Concluída']

  # Trades seed for test user Wátila Machado
  3.times do
    attributes = {
      status: "Proposta",
      user_id: user_bali[:id],
      area_id: watila_areas.sample[:id]
    }
    Trade.create!(attributes)
  end


  # Trades seeds for aleatory users
    30.times do
      attributes = {
        status:  trade_status_options.sample,
        user_id: users_ids.sample,
        area_id: areas_ids.sample
      }
      Trade.create!(attributes)
    end


  puts "Trades seeded!"

# end   ============ TRADES ======================






# start ============ REVIEWS ======================

  puts "Clearing Reviews table"

  Review.destroy_all

  # Support variables for Review seeding
    review_description_faker = [
      "Gostei muito. Recomendo.",
      "Foi tudo muito bem. Recomendo parceria com este usuário.",
      "O reflorestamento já está avançado!",
      "Tudo certo.",
      "Nada a comentar, tudo correu como esperado.",
      "Foi um achado!. Já resolvemos tudo!",
      "Nota 10!",
      "Muito bom."
    ]

    finished_trades = Trade.where(status: 'Concluída')

  # Review seeding for every Trade seeded as finished
    finished_trades.each do |fn_trade|
      attributes = {
        trade_id: fn_trade[:id],
        user_id: fn_trade[:user_id],
        description: review_description_faker.sample
      }
      Review.create!(attributes)
    end


  puts "Seeding Reviews table"

#  end ============= REVIEWS ======================
