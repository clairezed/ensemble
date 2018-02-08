module LanguageHelper

  def language_options(languages = Language.all)
    languages.order(title: :asc).map do |language|
      [language.title, language.id]
    end
  end

end