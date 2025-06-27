require "rails_helper"

RSpec.describe User, type: :model do
  it "is valid with email and password" do
    user = User.new(email: "test@example.com", password: "password", password_confirmation: "password")
    expect(user).to be_valid
  end

  it "is invalid without email" do
    user = User.new(password: "password", password_confirmation: "password")

    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is invalid if email is not unique" do
    User.create!(email: "test@example.com", password: "password", password_confirmation: "password")
    user = User.new(email: "test@example.com", password: "another", password_confirmation: "another")
    expect(user).not_to be_valid
  end

  it "authenticates with correct password" do
    user = User.create!(email: "test@example.com", password: "secret", password_confirmation: "secret")
    expect(user.authenticate("secret")).to eq(user)
  end

  it "does not authenticate with wrong password" do
    user = User.create!(email: "test@example.com", password: "secret", password_confirmation: "secret")
    expect(user.authenticate("wrong")).to be_falsey
  end
end
