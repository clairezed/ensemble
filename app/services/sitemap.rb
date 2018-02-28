module Sitemap

  def self.get_all_pages

    hash = []

    # Page d'accueil
    h = {loc: Rails.application.routes.url_helpers.root_url, priority: 1, lastmod: Time.now.strftime("%Y-%m-%d"),
      title: "Accueil", href: true, elements: []}
    hash << { home: h }

    # Inscription
    registration = {loc: Rails.application.routes.url_helpers.new_user_registration_path, priority: 0.8, lastmod: Time.now.strftime("%Y-%m-%d"),
      title: "Inscription", href: true, elements: []}
    hash << { registration: registration }

    # Connexion
    sign_in = {loc: Rails.application.routes.url_helpers.new_user_session_path, priority: 0.8, lastmod: Time.now.strftime("%Y-%m-%d"),
      title: "Connexion", href: true, elements: []}
    hash << { sign_in: sign_in }

    # Mot de passe oublié
    password = {loc: Rails.application.routes.url_helpers.new_user_password_path, priority: 0.5, lastmod: Time.now.strftime("%Y-%m-%d"),
      title: "Mot de passe oublié ?", href: true, elements: []}
    hash << { password: password }

    # Pas mail confirmation
    confirmation = {loc: Rails.application.routes.url_helpers.new_user_confirmation_path, priority: 0.5, lastmod: Time.now.strftime("%Y-%m-%d"),
      title: "Vous n'avez pas reçu le mail de validation ?", href: true, elements: []}
    hash << { confirmation: confirmation }

   #  # Fiches outil ===================================================

   #  # Axes

   #  axes = {loc: "#", priority: 1, lastmod: Time.now.strftime("%Y-%m-%d"),
   #    title: "Fiches outils", href: false, elements: []}
   #  hash << { axes: axes }

   # axes.includes(:seo).joins(:seo).each do |axis|
   #    axis_elt = {loc: Rails.application.routes.url_helpers.tools_url(by_axis: axis.id),
   #    priority: 0.9, lastmod: axis.updated_at.strftime("%Y-%m-%d"), title: axis.title, href: true, elements: []}

   #  # Fiches
   #    axis.tools.enabled.each do |tool|
   #      tool_elt = {loc: Rails.application.routes.url_helpers.tool_url(tool),
   #      priority: 0.7, lastmod: Time.now.strftime("%Y-%m-%d"), title: tool.title, href: true, elements: []}
   #      axis_elt[:elements] << { tool: tool_elt }
   #    end

   #    axes[:elements] << { axis: axis_elt }
   #  end

    # A propos -----------------------------------------------------
    # about_page = BasicPage.enabled.where(id_key: 'about', theme:.first
    # h = {loc: Rails.application.routes.url_helpers.basic_page_url(about_page), priority: 0.6, lastmod: Time.now.strftime("%Y-%m-%d"),
    #   title: "A propos", href: true, elements: []}
    # hash << { home: h }

    # Infos legales
    BasicPage.order(:position).each do |page|
      page_elt = {loc: Rails.application.routes.url_helpers.basic_page_path(page),
      priority: 0.6, lastmod: Time.now.strftime("%Y-%m-%d"), title: page.title, href: true, elements: []}
      hash << { page: page_elt }
    end

    hash

  end
end
