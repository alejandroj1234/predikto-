require 'rails_helper'

feature "sign-in" do
  scenario "homepage requires login" do
    visit "/"
    expect(page).to have_content("Log In")
  end

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
    click_link "Log Out"

    visit "/users/sign_in"
    fill_in "Email"                 , with: email
    fill_in "Password"              , with: password
    click_button "Log in"
    expect(page).to have_content("Predikto Account Log Out")
  end

  scenario "we see an error when we fail login" do
    visit "/users/sign_in"
    fill_in "Email"    , with: "foo"
    fill_in "Password" , with: "bar"
    click_button "Log in"
    expect(page).to have_content("Invalid Email or password")
  end
end