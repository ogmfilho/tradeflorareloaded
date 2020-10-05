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
  data = JSON.parse(open(URL2).read)
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
    10.times do
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
    10.times do
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

    #area_latlong_faker = [
      #{ name:"Amazônica", range_lat:(-9.297093..-0.165376), range_long:(-65.171125..-52.210211) },
      #{ name:"Atlântico Leste", range_lat:(-12.904332..-10.925327), range_long:(-39.934120..-38.771828) },
      #{ name:"Atlântico Nordeste Oriental", range_lat:(-7.049664..-5.594422), range_long:(-39.119006..-35.858550) },
      #{ name:"Atlântico Nordeste Ocidental", range_lat:(-5.654485..-3.630362), range_long:(-45.159619..-43.433360) },
      #{ name:"Atlântico Sudeste", range_lat:(-21.537241..-18.205200), range_long:(-43.217002..-41.295759) },
      #{ name:"Atlântico Sul", range_lat:(-31.033515..-29.056450), range_long:(-53.250156..-51.883939) },
      #{ name:"Paraguai", range_lat:(-18.343451..-11.907992), range_long:(-57.096231..-53.901001) },
      #{ name:"Paraná", range_lat:(-24.945905..-21.582357), range_long:(-53.075268..-48.049063) },
      #{ name:"Parnaíba", range_lat:(-7.131784..-5.193976), range_long:(-43.213586..-42.593224) },
      #{ name:"São Francisco", range_lat:(-12.034531..-9.728735), range_long:(-43.421399..-42.119223) },
      #{ name:"Tocantins-Araguaia", range_lat:(-13.271896..-3.246820), range_long:(-50.530603..-46.122949) },
      #{ name:"Uruguai", range_lat:(-30.294418..-29.033095), range_long:(-56.032921..-54.474580) },
    # ]




  # Area seeds for aleatory users
    # 25.times do
    #   basin_seed = Basin.all.sample
    #   city_seed = City.all.sample

    #   area_latlong_sample = area_latlong_faker.find { |basin| basin[:name] == basin_seed[:name] }

    #   attributes = {
    #      description: area_description_faker.sample,
    #      #coordinates:
    #      extension: rand(10..100),
    #      status: true,
    #      latitude: rand(area_latlong_sample[:range_lat]),
    #      longitude: rand(area_latlong_sample[:range_long]),
    #      # address:
    #      city_id: city_seed[:id],
    #      basin_id: basin_seed[:id],
    #      user_id: users_ids.sample
    #   }
    #   new_area = Area.create!(attributes)
    #   puts "Area created for user #{new_area[:user_id]}"
    # end

    #Áreas criadas para o demo day
      basin_seed = Basin.find_by(name: "Amazônica")
      city_seed = City.find_by(name: "Oriximiná")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-56.45625606508351,-1.6759220219984456,-56.443840120248595,-1.6695195566602195,-56.438297611443346,-1.6808050271842205,-56.45625606508351,-1.6759220219984456",
         extension: 108,
         status: true,
         latitude: -1.68,
         longitude: -56.45,
         address: "FLONA Saracá",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "Amazônica")
      city_seed = City.find_by(name: "Tefé")

      attributes = {
         description: area_description_faker.sample,

         coordinates:"-64.70566885294816,-3.3618824427553733,-64.70618860263961,-3.360740960572315,-64.7054817430591,-3.3605749266881304,-64.70494120338006,-3.3616956548529515,-64.70566885294816,-3.3618824427553733",
         extension: 2,
         status: true,
         latitude: -3.36,
         longitude: -64.71,
         address:"",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "Paraguai")
      city_seed = City.find_by(name: "Rondonópolis")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-54.92703928163091,-16.635744686647328,-54.905339461004985,-16.689315435882335,-54.811306904963075,-16.648805604040092,-54.845525852871575,-16.62641491521238,-54.92703928163091,-16.635744686647328",
         extension: 4700,
         status: true,
         latitude: -16.65,
         longitude: -54.87,
         address: "Ponte de pedra",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "Paraguai")
      city_seed = City.find_by(name: "Cuiabá")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-57.11843726620478,-15.429904155635185,-57.10923350917324,-15.402637124617698,-57.093519777656425,-15.402853543708389,-57.11843726620478,-15.429904155635185",
         extension: 257,
         status: true,
         latitude: -15.41,
         longitude: -57.11,
         address: "Porto estrela",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "Atlântico Leste")
      city_seed = City.find_by(name: "Canavieiras")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-39.08379459013315,-15.603493932475686,-39.09069250119461,-15.602444925068554,-39.085246781935666,-15.589506726168707,-39.08379459013315,-15.603493932475686",
         extension: 400,
         status: true,
         latitude: -15.60,
         longitude: -39.09,
         address: "Reserva",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"


      basin_seed = Basin.find_by(name: "Atlântico Leste")
      city_seed = City.find_by(name: "Eunápolis")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-39.9699045696768,-16.393819750148978,-39.96982436816995,-16.39051126470015,-39.964290464184614,-16.39112680113159,-39.9699045696768,-16.393819750148978",
         extension: 10,
         status: true,
         latitude: -16.39,
         longitude: -39.97,
         address: "Parque Nacional",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "Atlântico Nordeste Oriental")
      city_seed = City.find_by(name: "Serra do Mel")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-37.106684345700785,-5.276754604140706,-37.10618721992154,-5.264712318943353,-37.084664680179145,-5.26490894042324,-37.08367740771391,-5.276804424220671,-37.106684345700785,-5.276754604140706",
         extension: 328,
         status: true,
         latitude: -5.27,
         longitude: -37.10,
         address: "",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "Atlântico Nordeste Oriental")
      city_seed = City.find_by(name: "Ingá")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-35.64276614526173,-7.283396075667696,-35.6431057749773,-7.281790233702878,-35.64015099645093,-7.282632459227187,-35.64276614526173,-7.283396075667696",
         extension: 3,
         status: true,
         latitude: -7.28,
         longitude: -35.64,
         address: "",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "Atlântico Nordeste Ocidental")
      city_seed = City.find_by(name: "Tutóia")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-42.37180943932151,-2.8578755645276033,-42.33539028062134,-2.8511083141568747,-42.36291638894079,-2.8845212241067912,-42.37180943932151,-2.8578755645276033",
         extension: 637,
         status: true,
         latitude: -2.86,
         longitude: -42.36,
         address: "",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "Atlântico Nordeste Ocidental")
      city_seed = City.find_by(name: "São Bernardo")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-42.31843219473663,-3.2633643684829394,-42.31139041366188,-3.272828273071113,-42.29906729678197,-3.266203549229715,-42.30624449672325,-3.257685982929715,-42.31843219473663,-3.2633643684829394",
         extension: 190,
         status: true,
         latitude: -5.31,
         longitude: -38.99,
         address: "coqueiro",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "Atlântico Sudeste")
      city_seed = City.find_by(name: "Vitória")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-40.32682579910812,-20.301758719720496,-40.325529645790425,-20.30116054943018,-40.32489185606346,-20.302800688258472,-40.32682579910812,-20.301758719720496",
         extension: 1,
         status: true,
         latitude: -20.30,
         longitude: -40.33,
         address: "jucutucuara",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "Atlântico Sudeste")
      city_seed = City.find_by(name: "Rio de Janeiro")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-43.28573416249205,-22.93339250522132,-43.285905510419354,-22.931631777335696,-43.28376875787151,-22.932236087414694,-43.28573416249205,-22.93339250522132",
         extension: 2,
         status: true,
         latitude: -22.93,
         longitude: -43.29,
         address: "Tijuca",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "Atlântico Sul")
      city_seed = City.find_by(name: "Erechim")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-52.17384905133527,-27.758782529570468,-52.179630224266205,-27.760740424765196,-52.183646065167935,-27.754453071165294,-52.17499656168755,-27.75335958130058,-52.17384905133527,-27.758782529570468",
         extension: 50,
         status: true,
         latitude: -27.76,
         longitude: -52.18,
         address: "Toldo",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "Atlântico Sul")
      city_seed = City.find_by(name: "Gramado")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-50.910098058940804,-29.38875035564476,-50.9089426077588,-29.3870361343956,-50.907724699755505,-29.38907687070118,-50.910098058940804,-29.38875035564476",
         extension: 2,
         status: true,
         latitude: -29.39,
         longitude: -50.91,
         address: "",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "Paraná")
      city_seed = City.find_by(name: "Jundiaí")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-46.91970310495043,-23.219486882236183,-46.92482533895401,-23.220987015039228,-46.920097122950324,-23.22429759332215,-46.91970310495043,-23.219486882236183",
         extension: 14,
         status: true,
         latitude: -23.22,
         longitude: -46.92,
         address: "",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "Paraná")
      city_seed = City.find_by(name: "Jacutinga")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-51.56684913794203,-24.255389470723784,-51.56850505880675,-24.251726437837902,-51.56508463210284,-24.251553183670367,-51.56478602342213,-24.252345200801457,-51.563320126263534,-24.253434216299937,-51.56291293260844,-24.25425097180488,-51.5636187349441,-24.254498472436836,-51.56239715397879,-24.256973452266678,-51.56467743844763,-24.25759218969769,-51.56684913794203,-24.255389470723784",
         extension: 23,
         status: true,
         latitude: -24.25,
         longitude: -51.56,
         address: "",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"


      basin_seed = Basin.find_by(name: "Parnaíba")
      city_seed = City.find_by(name: "Esperantina")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-42.212162634536924,-3.8840478311879565,-42.17958269854239,-3.904447340152302,-42.17845925247357,-3.8755292088142284,-42.212162634536924,-3.8840478311879565",
         extension: 596,
         status: true,
         latitude: -3.89,
         longitude: -42.19,
         address: "",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "Parnaíba")
      city_seed = City.find_by(name: "Tasso Fragoso")

      attributes = {
         description: area_description_faker.sample,
         coordinates:"-45.51466029173346,-8.436688136856873,-45.51281373497483,-8.401981666206567,-45.43119592624299,-8.40709649938806,-45.43156523759521,-8.442898439914103,-45.51466029173346,-8.436688136856873",
         extension: 3566,
         status: true,
         latitude: -8.42,
         longitude: -45.47,
         address: "",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "São Francisco")
      city_seed = City.find_by(name: "Pirapora")

      attributes = {
         description: area_description_faker.sample,
         coordinates: "-44.983684579551465,-17.356128381732162,-44.98648889385848,-17.353506097298265,-44.98921204999985,-17.354343617114665,-44.98642837927767,-17.358502279532175,-44.983684579551465,-17.356128381732162",
         extension: 16,
         status: true,
         latitude: -17.36,
         longitude: -44.99,
         address: "",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"


      basin_seed = Basin.find_by(name:  "Tocantins-Araguaia")
      city_seed = City.find_by(name: "Porangatu")

      attributes = {
         description: area_description_faker.sample,
         coordinates: "-49.12569833438829,-13.502835134083341,-49.12535648493548,-13.502117459778006,-49.12383215146454,-13.501486924224494,-49.122804228060176,-13.50297268598736,-49.12569833438829,-13.502835134083341",
         extension: 3,
         status: true,
         latitude: -13.50,
         longitude: -49.12,
         address: "",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name:  "Uruguai")
      city_seed = City.find_by(name: "Chapecó")

      attributes = {
         description: area_description_faker.sample,
         coordinates: "-52.54923994442147,-27.11936418526723,-52.546080191704846,-27.118249368087973,-52.544229886059725,-27.1198455801618,-52.545397001928066,-27.122252523556085,-52.549183011940215,-27.122379203351827,-52.54923994442147,-27.11936418526723",
         extension: 17,
         status: true,
         latitude: -27.12,
         longitude: -52.55,
         address: "",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"


      basin_seed = Basin.find_by(name:  "Uruguai")
      city_seed = City.find_by(name: "Ouro Verde")

      attributes = {
         description: area_description_faker.sample,
         coordinates: "-52.009750591846625,-26.705074198317988,-52.01143019997126,-26.702173297175342,-52.000960642662875,-26.703273647685236,-52.009750591846625,-26.705074198317988",
         extension: 15,
         status: true,
         latitude: -26.70,
         longitude: -52.01,
         address: "",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: users_ids.sample
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

  # Area seeds for test user Wátila Machado
  
      basin_seed = Basin.find_by(name: "São Francisco")
      city_seed = City.find_by(name: "Unaí")

      attributes = {
         description: area_description_faker.sample,

         coordinates: "-45.51466029173346,-8.436688136856873,-45.51281373497483,-8.401981666206567,-45.43119592624299,-8.40709649938806,-45.43156523759521,-8.442898439914103,-45.51466029173346,-8.436688136856873",
         extension: 3641,
         status: true,
         latitude: -12.27,
         longitude: -46.36,
         address: "",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: user_watila[:id]
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"

      basin_seed = Basin.find_by(name: "Tocantins-Araguaia")
      city_seed = City.find_by(name: "Brasília")

      attributes = {
         description: area_description_faker.sample,
         coordinates: "-48.22839212185394,-15.673846530123612,-48.22693777646256,-15.670385024175232,-48.22554666347938,-15.670780757790581,-48.226906160258466,-15.674981575046843,-48.22839212185394,-15.673846530123612",
         extension: 7,
         status: true,
         latitude: -15.67,
         longitude: -48.23,
         address: "",
         city_id: city_seed[:id],
         basin_id: basin_seed[:id],
         user_id: user_watila[:id]
      }
      new_area = Area.create!(attributes)
      puts "Area created for user #{new_area[:user_id]}"


   



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
