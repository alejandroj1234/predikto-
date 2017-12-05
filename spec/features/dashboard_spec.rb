require 'rails_helper'

feature "create-transaction" do
  scenario "we can log in" do
    visit "/"

    click_link "Sign Up"

    email = "user#{rand(10000)}@example.com"
    password = "qwertyuiop"

    fill_in "Email"                 , with: email
    fill_in "Password"              , with: password
    fill_in "Password confirmation" , with: password

    click_button "Sign up"
    expect(page).to have_content("Predikto Account Log Out")
    select("EUR", from: "base_currency").select_option




    #visit "/users/sign_in"
    #fill_in "Email"                 , with: email
    #fill_in "Password"              , with: password
    #click_button "Log in"
    #expect(page).to have_content("Predikto Account Log Out")
  end
end