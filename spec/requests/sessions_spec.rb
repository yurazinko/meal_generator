RSpec.describe "User login/logout", type: :request do
  let!(:user) { User.create!(email: "test@example.com", password: "password", password_confirmation: "password") }

  it "logs in with valid credentials" do
    post login_path, params: { email: "test@example.com", password: "password" }

    expect(session[:user_id]).to eq(user.id)
    expect(response).to redirect_to(root_path)
  end

  it "fails login with wrong password" do
    post login_path, params: { email: "test@example.com", password: "wrong" }

    expect(session[:user_id]).to be_nil
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("Invalid email or password")
  end

  it "logs out" do
    post login_path, params: { email: "test@example.com", password: "password" }
    delete logout_path

    expect(session[:user_id]).to be_nil
    expect(response).to redirect_to(root_path)
  end
end
