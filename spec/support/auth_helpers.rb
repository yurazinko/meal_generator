module AuthHelpers
  def sign_in_as(user)
    post login_path, params: {
      email: user.email,
      password: "password"
    }
  end
end
