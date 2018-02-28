# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'


a1 = Admin.where(email: 'clairezuliani@gmail.com').first_or_create(password: 'password')
Seo.where(param: 'home').first_or_create


# Import villes
p "Cities ------------------" 
unless City.any?
  if Rails.env.test?
    csv_doc = "docs/communes_gps_vosges.csv"
  else
    csv_doc = "docs/communes_gps.csv"
  end

  CSV.foreach(csv_doc ,{headers: :true, col_sep: ';'}) do |row|
    city = City.where(insee: row['10_code_insee']).first_or_initialize
    if city.new_record?
      city.update_attributes(
        department_name: row[5],
        department_code: row[4],
        name: row['08_nom_commune'],
        normalized_name: ActiveSupport::Inflector.transliterate(row['08_nom_commune']).parameterize,
        zipcode: row['09_codes_postaux'],
        latitude: row['11_latitude'],
        longitude: row['12_longitude'],
        )
      p city.errors unless city.valid?
    end
  end
end
p "End Cities ------------------"

LANGUAGES = [ "Anglais", "Arabe", "Chinois", "Espagnol", "Français", "Russe", "Albanais", "Allemand", "Amazighe", 
  "Arménien", "Aymara", "Bengali", "Catalan", "Coréen", "Croate", "Danois", "Finnois", "Guarani", "Grec", 
  "Hongrois", "Italien", "Kiswahili", "Malais", "Mongol", "Néerlandais", "Occitan", "Ourdou", "Persan", "Portugais", 
  "Quechua", "Roumain", "Samoan", "Serbe", "Sesotho", "Slovaque", "Slovène", "Suédois", "Tamoul", "Turc", "Afrikaans", 
  "Amharique", "Araona", "Azéri", "Baure", "Bésiro", "Bichelamar", "Biélorusse", "Birman", "Bulgare", "Canichana", 
  "Cavineña", "Cayubaba", "Chácobo", "Chichewa", "Chimane", "Cinghalais", "Créole de Guinée-Bissau", 
  "Créole haïtien", "Créole seychellois", "Divehi", "Dzongkha", "Ese 'Ejja", "Estonien", "Fidjien", "Filipino", 
  "Géorgien", "Gilbertin", "Guarasu’we", "Guarayu", "Hébreu", "Hindoustani", "Hindi", "Hiri Motu", "Indonésien", 
  "Irlandais", "Islandais", "Itonama", "Japonais", "Kallawaya", "Kazakh", "Khmer", "Kirghiz", "Kirundi", "Lao", 
  "Langue des signes néo-zélandaise", "Latin", "Leko", "Letton", "Lituanien", "Luxembourgeois", "Macédonien", 
  "Machineri", "Malgache", "Maltais", "Māori", "Māori des Îles Cook", "Maropa", "Marshallais", "Mirandais", 
  "Mojeño-Trinitario", "Mojeño-Ignaciano", "Monténégrin", "Moré", "Mosetén", "Movima", "Nauruan", "Népalais", 
  "Norvégien", "Ouzbek", "Pacahuara", "Pachto", "Paluan", "Polonais", "Puquina", "Sango", "Shikomor", "Shona", 
  "Shuar", "Sindebele", "Sirionó", "Somali", "Tacana", "Tadjik", "Tamazight", "Tapiete", "Tchèque", "Tétoum", 
  "Tigrinya", "Thaï", "Tok Pisin", "Tonguien", "Toromona", "Turkmène", "Tuvaluan", "Ukrainien", "Uru-Chipaya", 
  "Vietnamien", "Wichi", "Yaminahua", "Yuki", "Yaracaré", "Zamuco", "Angaur", "Basque", "Cantonais", "Carolinien", 
  "Chamorro", "Galicien", "Gallois", "Hatohabei", "Hawaïen", "Inuktitut", "Ladin", "Mannois", "Mirandais", 
  "Napolitain", "Ndébélé", "Occitan (aranais)", "Ouïghour", "Romanche", "Ruthène", "Sarde", "Sorabe", 
  "Sotho du Nord", "Sotho du Sud", "Swati", "Tibétain", "Tsonga", "Tswana", "Venda", "Xhosa", "Zoulou"
]

p "languages ------------------"
LANGUAGES.each do |language_title|
  key_language = language_title.parameterize
  language = Language.where(key: key_language).first_or_initialize
  language.update_attributes( title: language_title ) if language.new_record?
end
p "End languages ------------------"

# Leisures
p "Leisures ------------------"
[
  { category_title: "Sports", category_key: "activites-sportives", leisures: [
    {title: "Sports de balles", key: "sports-de-balles"},
    {title: "Sports de boules", key: "sports-de-boules"},
    {title: "Sports de glisse", key: "sports-de-glisse"},
    {title: "Sports de d'eau",  key: "sports-d-eau"},
    {title: "Sports de raquettes", key: "sports-de-raquettes"},
    {title: "Sports de combat", key: "sports-de-combat"},
    {title: "Sports à pied", key: "sports-a-pied"},
    {title: "Sports à roue", key: "sports-a-roue"},
    {title: "Aller voir du sport", key: "aller-voir-du-sport"},
    {title: "Autre", key: "autre"},
  ]},
  { category_title: "À table", category_key: "activites-culinaires", leisures: [
    {title: "Cuisine à la maison", key: "cuisine-a-la-maison"},
    {title: "Restaurant", key: "restaurant"},
    {title: "Pique-nique", key: "pique-nique"},
    {title: "Autre", key: "autre"},
  ]},
  { category_title: "Culture", category_key: "activites-culturelles", leisures: [
    {title: "Cinéma", key: "cinema"},
    {title: "Concert", key: "concert"},
    {title: "Spectacle", key: "spectacle"},
    {title: "Musée", key: "musee"},
    {title: "Tourisme", key: "tourisme"},
    {title: "Autre", key: "autre"},
  ]},
  { category_title: "Arts", category_key: "activites-artistiques", leisures: [
    {title: "Jouer de la musique", key: "jouer-de-la-musique"},
    {title: "Chanter", key: "chanter"},
    {title: "Peindre-dessiner", key: "peindre-dessiner"},
    {title: "Photographier", key: "photographier"},
    {title: "Danser", key: "danser"},
    {title: "Autre", key: "autre"},
  ]},
    { category_title: "Avec les mains", category_key: "activites-manuelles", leisures: [
    {title: "Couture-tricot", key: "couture-tricot"},
    {title: "Jardinage", key: "jardinage"},
    {title: "Bricolage", key: "bricolage"},
    {title: "Autre", key: "autre"},
  ]},
    { category_title: "Jeux", category_key: "activites-ludiques", leisures: [
    {title: "Jeux de cartes", key: "jeux-de-cartes"},
    {title: "Jeux de plateaux", key: "jeux-de-plateaux"},
    {title: "Jeux vidéo", key: "jeux-video"},
    {title: "Autre", key: "autre"},
  ]},
  { category_title: "Détente", category_key: "activites-de-detente", leisures: [
    {title: "Soirée à la maison", key: "soiree-a-la-maison"},
    {title: "Discussion", key: "discussion"},
    {title: "Autre", key: "autre"},
  ]},
  { category_title: "En ville", category_key: "activites-en-ville", leisures: [
    {title: "Bar-café", key: "bar-cafe"},
    {title: "Discothèque", key: "discotheque"},
    {title: "Shopping", key: "shopping"},
    {title: "Autre", key: "autre"},
  ]},
].each do |category_hash|
  leisure_category = LeisureCategory.where(key: category_hash[:category_key]).first_or_initialize
  leisure_category.update_attributes( title: category_hash[:category_title] ) if leisure_category.new_record?
  category_hash[:leisures].each do |leisure_hash|
    leisure = leisure_category.leisures.where(key: leisure_hash[:key]).first_or_initialize
    leisure.update_attributes( title: leisure_hash[:title] ) if leisure.new_record?
  end
end
p "End leisures ------------------"

# Utilisateur mirador --------------------------
mirador_user = User.where(email: 'contact@ensemble-app.fr').first_or_initialize
mirador_user.update_attributes(
  phone: "+33612310286",
  password: 'password',
  firstname: 'Elodie',
  lastname: 'Mirador',
  birthdate: '1985-03-15',
  sms_notification: false,
  email_notification: true,
  registration_complete: true,
  affiliation: 'mirador',
  city_id: City.where(normalized_name: 'epinal').first.id,
  verification_state: 'admin_accepted',
  confirmed_at: Time.current,
  sms_confirmed_at: Time.current,
  cgu_accepted_at: Time.current
)


# Basïc Pages ==================================================
[
  # { key: 'data_policy', title: "Charte des données personnelles", enabled: true },
  { key: 'who_we_are', title: "Qui sommes-nous ?", enabled: true },
  { key: 'cgu', title: "Conditions Générales d'Utilisation", enabled: true },
  { key: 'legal_mentions', title: "Mentions légales", enabled: true },
  { key: 'cookies', title: "Cookies", enabled: true }
].each do |option|
  BasicPage.where(key: option[:key]).first_or_create(
    enabled: option[:enabled], 
    title: option[:title]
  )
end