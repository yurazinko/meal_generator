RSpec.describe "User registration", type: :request do
  it "registers user with valid data" do
    post signup_path, params: {
      user: {
        email: "test@example.com",
        password: "password",
        password_confirmation: "password"
      }
    }

    expect(response).to redirect_to(root_path)

    follow_redirect!

    expect(response.body).to include("Meal Generator")
    expect(session[:user_id]).not_to be_nil
  end

  it "renders errors with invalid data" do
    post signup_path, params: { user: { email: "", password: "x", password_confirmation: "y" } }

    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("error")
  end
end
