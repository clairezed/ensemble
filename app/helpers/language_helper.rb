module LanguageHelper

  def language_options(languages = Language.all)
    languages.map do |language|
      [language.title, language.id]
    end
  end

end