require 'acceptance/acceptance_helper'
require "rails_helper"
feature 'Home Page' do

  scenario 'user accessing home' do
    visit root_path
    page.should have_content('Welcome to our app')
  end

end
