require 'open-uri'
require 'json'
require 'faker'
require 'brazilian_documents'




# start ============ CLEAR TABLES ======================


  puts "Clearing Reviews table"
  Review.destroy_all

  puts "Clearing Trades table"
  Trade.destroy_all

  puts "Clearing Areas table"
  Area.destroy_all

  puts "Clearing Users table"
  User.destroy_all

  puts "Deleting all cities"
  City.delete_all

  puts "Deleting all states"
  State.delete_all

  puts "Clearing Basins table"
  Basin.destroy_all

# end ============ CLEAR TABLES ======================





# start ============ STATES ======================

  URL = "https://servicodados.ibge.gov.br/api/v1/localidades/estados"

  states = JSON.parse(open(URL).read)
  states.each do |object|
    new_state = State.create!(name: object["nome"])
    puts "Creating #{new_state.name}"
  end
# end   ============ STATES ======================





# start ============ CITIES ======================

  URL2 = "https://servicodados.ibge.gov.br/api/v1/localidades/municipios"
  data = JSON.parse(open(URL2).read)#.sample(100)
  data.each do |object|
    new_city = City.create!(name: object["nome"], state_id: State.find_by(name: object["microrregiao"]["mesorregiao"]["UF"]["nome"])[:id])
    puts "Creating #{new_city.name}"
  end
# end   ============ CITIES ======================







# start ============ BASINS ======================


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
                   phone_number:Faker::PhoneNumber.cell_phone,
                   address: Faker::Address.street_address
                   }
     normalized_name = I18n.transliterate(attributes[:name]).downcase
     attributes[:email]="watila@mail.com"
     attributes[:city_id] = City.all.sample.id
     new_user = User.create!(attributes)
     puts "Creating #{new_user[:name]}"
    end


  # Usuário Bali Mineradora
    1.times do
      attributes = {name: "Bali Mineradora",
                   password: "123456",
                   document_number: BRDocuments::CNPJ.generate,
                   phone_number:Faker::PhoneNumber.cell_phone,
                   address: Faker::Address.street_address
                   }
     normalized_name = I18n.transliterate(attributes[:name]).downcase
     attributes[:email]="bali@mail.com"
     attributes[:city_id] = City.all.sample.id
     new_user = User.create!(attributes)
     puts "Creating #{new_user[:name]}"
    end


  # Pessoa Física
    20.times do
     attributes = {name: Faker::Name.unique.name,
                   password: "123456",
                   document_number: BRDocuments::CPF.generate,
                   phone_number:Faker::PhoneNumber.cell_phone,
                   address: Faker::Address.street_address
                   }
     normalized_name = I18n.transliterate(attributes[:name]).downcase
     attributes[:email]="#{normalized_name.split.first}.#{rand(10.1000)}@mail.com"
     attributes[:city_id] = City.all.sample.id
     new_user = User.create!(attributes)
     puts "Creating #{new_user[:name]}"
    end


  # Pessoa Jurídica
    20.times do
     attributes = {name: Faker::Company.unique.name,
                   password: "123456",
                   document_number: BRDocuments::CNPJ.generate,
                   phone_number:Faker::PhoneNumber.cell_phone,
                   address: Faker::Address.street_address
                   }
     normalized_name = I18n.transliterate(attributes[:name]).downcase
     attributes[:email]="#{normalized_name.split.first}.#{rand(10.1000)}@mail.com"
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


  puts "Seeding Areas table"

 # Support for Area seeding

    area_description_faker = [
      "Uma área rural disponível para reflorestamento",
      "Área para reflorestamento.",
      "Área para reflorestamento urgente!",
      "Preciso reflorestar.",
      "Disponível para reflorestamento. Fácil acesso.",
      "Cedo para reflorestamento."
      # "Área para reflorestamento na Bacia #{basin_seed[:name]}", # Não consigo resolver o acesso à variável, que só pode ser criada na iteração...
      # "Disponibilizo área na Bacia #{basin_seed[:name]}"
    ]

    area_latlong_faker = [
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




  # Area seeds for aleatory users
    25.times do
      basin_seed = Basin.all.sample
      city_seed = City.all.sample

      area_latlong_sample = area_latlong_faker.find { |basin| basin[:name] == basin_seed[:name] }

      attributes = {
         description: area_description_faker.sample,
         # coordinates: "{}"
         extension: rand(10..100),
         available?: true,
         latitude: rand(area_latlong_sample[:range_lat]),
         longitude: rand(area_latlong_sample[:range_long]),
         # address:
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"
    end

  # Area seeds for test user Wátila Machado
    4.times do
      basin_seed = Basin.all.sample
      city_seed = City.all.sample



      area_latlong_sample = area_latlong_faker.find { |basin| basin[:name] == basin_seed[:name] }


      attributes = {
         description: area_description_faker.sample,
         # coordinates: "{}"
         extension: rand(10..100),
         available?: true,
         latitude: rand(area_latlong_sample[:range_lat]),
         longitude: rand(area_latlong_sample[:range_long]),
         # address:
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: user_watila[:id]
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"
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


puts "Seeding Trades table"

  trade_status_options = ['Proposta', 'Visualizada', 'Aceita', 'Recusada', 'Concluída']
  trade_details_faker = [
    "Tenho interesse na área. Poderia me contatar?",
    "Por favor, entre em contato.",
    "Gostaria de reflorestar nessa bacia. Podemos conversar?",
    "Como poderíamos fazer? Preciso fazer a compensação ambiental nesta região.",
    "Seguem os meus contatos. Fico aguardando.",
    "Temos interesse em realizar o reflorestamento da sua área."
  ]

  # Trades seed for test user Wátila Machado
  3.times do
    attributes = {
      details: trade_details_faker.sample,
      status: "Proposta",
      user_id: user_bali[:id],
      area_id: watila_areas.sample[:id]
    }
    new_trade = Trade.create!(attributes)
    puts "Trade created for user #{new_trade[:user_id]}"
  end


  # Trades seeds for aleatory users
    30.times do
      attributes = {
        details: trade_details_faker.sample,
        status:  trade_status_options.sample,
        user_id: users_ids.sample,
        area_id: areas_ids.sample
      }
      new_trade = Trade.create!(attributes)
      puts "Trade created for user #{new_trade[:user_id]}"
    end


  puts "Trades seeded!"

# end   ============ TRADES ======================






# start ============ REVIEWS ======================

  puts "Seeding Reviews table"
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
    finished_trades.each do |finished_trade|
      attributes = {
        trade_id: finished_trade[:id],
        user_id: finished_trade[:user_id],
        description: review_description_faker.sample
      }
      new_review = Review.create!(attributes)
      puts "Review created for trade #{new_review[:trade_id]}"
    end

  puts "Reviews seeded!"


#  end ============= REVIEWS ======================
