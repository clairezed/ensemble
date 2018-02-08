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
  { category: "Activités sportives", leisures: [
    "Sports de balles",
    "Sports de boules",
    "Sports de glisse",
    "Sports d'eau ",
    "Sports de raquettes",
    "Sports de combat",
    "Sports à pied",
    "Sports à roue",
    "Aller voir du sport",
    "Autre",
  ]},
  { category: "Activités culinaires", leisures: [
    "Cuisine à la maison",
    "Restaurant",
    "Pique-nique",
    "Autre",
  ] },
  { category: "Activités culturelles", leisures: [
    "Cinéma",
    "Concert",
    "Spectacle",
    "Musée",
    "Tourisme",
    "Autre",
  ] },
  { category: "Activités artistiques", leisures: [
    "Jouer de la musique",
    "Chanter",
    "Peindre-dessiner",
    "Photographier",
    "Danser",
    "Autre",
  ] },
  { category: "Activités manuelles", leisures: [
    "Couture-tricot",
    "Jardinage",
    "Bricolage",
    "Autre",
  ] },
  { category: "Activités ludiques", leisures: [
    "Jeux de cartes",
    "Jeux de plateaux",
    "Jeux vidéo,",
    "Autre",
  ] },
  { category: "Activités de détente", leisures: [
    "Soirée à la maison",
    "Discussion",
    "Autre",
  ] },
  { category: "Activités en ville", leisures: [
    "Bar-café",
    "Discothèque",
    "Shopping",
    "Autre",
  ] },
].each do |category_hash|
  key_category = category_hash[:category].parameterize
  leisure_category = LeisureCategory.where(key: key_category).first_or_initialize
  leisure_category.update_attributes( title: category_hash[:category] ) if leisure_category.new_record?
  category_hash[:leisures].each do |leisure_title|
    key_leisure = leisure_title.parameterize
    leisure = leisure_category.leisures.where(key: key_leisure).first_or_initialize
    leisure.update_attributes( title: leisure_title ) if leisure.new_record?
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