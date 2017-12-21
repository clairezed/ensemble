require "rails_helper"

feature "Inscription/Connexion User" do
  before(:each) do
    @user = create(:user)
  end

#   scenario "User se connecte avec de bons identifiants" do
#     visit root_path

#     click_link "Se connecter"
#     expect(current_path).to eq(new_user_session_path)

#     fill_in "user_email", with: @user.email
#     fill_in "user_password", with: "password"
#     click_button "Je me connecte"
#     expect(current_path).to eq(main_information_path)

#     find('#main-info-link').click
#     expect(current_path).to eq(main_information_path)
#   end

#   scenario "User se connecte avec de mauvais identifiants" do
#     visit root_path

#     click_link "Se connecter"
#     expect(current_path).to eq(new_user_session_path)

#     fill_in "user_email", with: @user.email
#     fill_in "user_password", with: "wrong_password"
#     click_button "Je me connecte"
#     expect(current_path).to eq(new_user_session_path)

#     # Capybara does not find js flash messages
#     #expect(page).to have_content 'invalides'

#     expect_user_to_not_be_logged
#   end

#   scenario "Inscription utilisateur" do
#     visit new_user_registration_path
#     click_button "Je m'inscris"

#     expect(current_path).to eq(user_registration_path)
#     expect(page).to have_content 'erreurs'

#     fill_user_inputs
#     click_button "Je m'inscris"

#     # Le compte ne doit pas être confirmé
#     new_user = User.where(email: "user2@email.com").first
#     expect(new_user.confirmed?).not_to be true
#     expect(current_path).to eq(root_path)
#     expect_user_to_not_be_logged

#     # On va confirmer le compte dans le mail
#     mail = unread_emails_for(new_user.email).first
#     expect(mail).not_to be_nil
#     set_current_email(mail)
#     visit_in_email("Confirmer mon inscription")

#     new_user.reload
#     expect(new_user.confirmed?).to be true
#     expect_user_to_not_be_logged
#   end

#   scenario "Process mot de passe oublié" do
#     visit new_user_registration_path
#     click_link "Vous avez oublié votre mot de passe ?"

#     fill_in("user_email", with: @user.email)
#     click_button "Valider"

#     expect(current_path).to eq(new_user_session_path)
#     expect_user_to_not_be_logged
#     mail = unread_emails_for(@user.email).first
#     expect(mail).not_to be_nil
#     set_current_email(mail)
#     visit_in_email("Choisir un nouveau mot de passe")
#     expect(current_path).to eq(edit_user_password_path)
#     fill_in("user_password", with: "new_password")
#     fill_in("user_password_confirmation", with: "new_password")
#     find('input[name="commit"]').click
#     expect_user_to_be_logged
#     @user.reload
#     expect(@user.valid_password?("new_password")).to be true
#   end

#   scenario "Déconnexion" do
#     user_log_in
#     find('#logout').click
#     expect_user_to_not_be_logged
#   end



#   scenario "Desactivation du compte" do

#     user_log_in
#     expect_user_to_be_logged
#     visit(edit_user_registration_path)
#     find('#destroy-account-link').click
#     expect_user_to_not_be_logged
#     expect(@user.reload.deactivated?).to eq(true)
#   end

#   scenario "User ajouté par un admin" do
#     login_as @admin, scope: :admin
#     visit admin_users_path

#     expect(page).to have_content(@user.email)
#     expect(page).not_to have_content("user2@email.com")

#     click_link "Ajouter un utilisateur"
#     click_button "submit_and_stay"
#     expect(page).to have_content("erreurs")

#     fill_user_inputs
#     click_button "submit_and_leave"

#     expect(current_path).to eq(admin_users_path)
#     expect(page).to have_content("user2@email.com")
#   end

#   scenario "User édité par un admin" do
#     login_as @admin, scope: :admin
#     visit edit_admin_user_path(@user)

#     fill_in("user_firstname", with: "nouveau-prenom")
#     click_button "submit_and_stay"
#     expect(page).not_to have_content("erreurs")

#     click_button "submit_and_leave"

#     expect(current_path).to eq(admin_users_path)
#     expect(page).to have_content("nouveau-prenom")
#   end

#   scenario "User supprimé par un admin" do
#     login_as @admin, scope: :admin
#     visit admin_users_path

#     expect(page).to have_content(@user.email)

#     page.find("#delete-user-#{@user.id}").click

#     expect(current_path).to eq(admin_users_path)
#     expect(page).not_to have_content(@user.email)
#   end

# end

def fill_user_inputs
  fill_in("user_lastname", with: "nom")
  fill_in("user_firstname", with: "prenom")
  fill_in("user_nickname", with: "pseudo")
  fill_in("user_email", with: "user2@email.com")
  fill_in("user_company", with: "Studio HB")
  fill_in("user_password", with: "password")
  fill_in("user_password_confirmation", with: "password")
  first('input#locality', visible: false).set("Lyon")
end

def expect_user_to_not_be_logged
  visit(edit_user_registration_path)
  expect(current_path).to eq(new_user_session_path)
end

def expect_user_to_be_logged
  visit(edit_user_registration_path)
  expect(current_path).to eq(edit_user_registration_path)
end

def user_log_in
  login_as @user, scope: :user
  expect_user_to_be_logged
end