require "rails_helper"

feature "Verification User" do

  # TODO : ajouter le grade

  # scenario "user can complete two steps registration", js: true do
  context "With nothing verified" do
    let!(:user) { create(:user, :registration_complete) }

    scenario "user can access app immediatly with no verification" do
      expect(user.active_for_authentication?).to be true
      sign_in_user(user)
      visit authenticated_root_path
      expect(current_path).to eq(authenticated_root_path)
      expect(user.sms_confirmed?).to be false
      expect(user.confirmed?).to be false
      expect(user.verification_state).to eq('pending')
    end

    scenario "user can access app until limit" do
      travel User.allow_unconfirmed_access_for - 1.day do
        expect(user.active_for_authentication?).to be true
        sign_in_user(user)
        # save_and_open_page
        expect(current_path).to eq(authenticated_root_path)
      end
    end

    scenario "user cant access app after limit" do
      travel User.allow_unconfirmed_access_for + 1.hour do
        expect(user.active_for_authentication?).to be false
        sign_in_user(user)
        expect(current_path).to eq(new_user_confirmation_path)
      end
    end
  end 

  # # TODO ===========================================
  # context "after X days" do 
  #   scenario "user with no phone verification cant acceed app" do

  #   end

  #   scenario "user with no email verification cant acceed app" do 
  #   end

  #   scenario "user with no admin verification cant accedd app" do
  #     user = FactoryBot.create(:user, :registration_complete)
  #   end

  #   scenario "user that has verified email and phone changes states and can go back to the app" do 
  #   end

  #   scenario "user that has is admin verified changes states and can go back to the app" do 
  #   end
  # end

  context "when I change my contact info" do

    let!(:user) { create(:admin_accepted_user, email: 'email_1@mail.com') }

    before { login_as user, scope: :user }

    scenario "changing my email retrogrades me" do
      # verif initialisation
      expect(user.confirmed?).to be true
      expect(user.verification_state).to eq('admin_accepted')

      visit edit_users_parameters_path
      expect(current_path).to eq(edit_users_parameters_path)

      # Verif securite du changement d'email
      fill_in "user_email", with: "email_2@mail.com"
      click_button "Ok"
      expect(current_path).to eq(users_parameters_path)
      expect(page).to have_content 'erreurs'
      expect(page).to have_content 'sécurité'

      # Retrogradation apres changement d'email
      fill_in "user_email", with: "email_2@mail.com"
      fill_in "user_current_password", with: user.password
      click_button "Ok"
      expect(current_path).to eq(users_parameters_path)
      expect(page).to have_content 'Supprimer mon compte'
      user.reload
      expect(user.confirmed?).to be false
      expect(user.verification_state).to eq('pending')
      expect(user.active_for_authentication?).to be true

      # Blocage après 7 jours
      travel User.allow_unconfirmed_access_for + 1.hour do
        expect(user.active_for_authentication?).to be false
        visit root_path
        expect(current_path).to eq(new_user_confirmation_path)
      end
      # email non confirmé
      # email à revérifier
      # statut non confirmé
      # grade rétrogradé
      # peut toujours se connecter
      # bloqué après 7 jours
    end

    scenario "changing my phone retrogrades me" do
      # verif initialisation
      expect(user.sms_confirmed?).to be true
      expect(user.verification_state).to eq('admin_accepted')

      visit edit_users_parameters_path
      expect(current_path).to eq(edit_users_parameters_path)
      fill_in "user_phone", with: "0612345678"
      click_button "Ok"
      expect(current_path).to eq(users_parameters_path)
      expect(page).to have_content 'Supprimer mon compte'
      user.reload
      expect(user.reload.sms_confirmed?).to be false
      expect(user.verification_state).to eq('pending')
      expect(user.active_for_authentication?).to be true

      # Blocage après 7 jours
      travel User.allow_unconfirmed_access_for + 1.hour do
        expect(user.active_for_authentication?).to be false
        visit root_path
        expect(current_path).to eq(new_user_confirmation_path)
      end
      # tel non confirmé
      # tel à revérifier
      # statut non confirmé
      # grade rétrogradé
      # peut toujours se connecter
      # bloqué après 7 jours
    end

  end


end

# def fill_first_step
#   fill_in("user_email", with: "eglantine@mail.com")
#   fill_in("user_firstname", with: "Eglantine")
#   fill_in("user_lastname", with: "Zuliani")
#   fill_in("user_password", with: "Password1")
#   # fill_in("user_password_confirmation", with: "Password1")
# end

# def fill_second_step
#   choose "user_gender_female"
#   fill_in("user_phone", with: "0606060606")
#   select 'Epinal', from: 'user_city_id', visible: false
#   # select2_ajax "Epinal", :from => "Rechercher...", :minlength => 2
#   page.find("#user_birthdate", visible: false).set("02/05/1985")
#   # page.find("#user_leisure_ids_#{Leisure.first.id}", visible: false).set("02/05/1985")
#   check "user_cgu_accepted"
# end



def sign_in_user(user)
  visit root_path
  # save_and_open_page
  click_link "Connexion"
  expect(current_path).to eq(new_user_session_path)

  fill_in "user_email", with: user.email
  fill_in "user_password", with: user.password
  click_button "Connexion"
end

