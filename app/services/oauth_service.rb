# app/services/oauth_service.rb
# Handles OAuth connection and user management.
class OAuthService
  def initialize(auth, user_id = nil)
    @auth = auth
    @user_id = user_id
  end

  def connect_user
    @user_id.present? ? existing_user : new_user
  end

  private

  def existing_user
    user = User.find(@user_id)
    column, info = auth_type

    existing_user = User.find_by(column => info)

    if existing_user
      { success: false, user: user, alert: "Account already exists with those credentials." }
    else
      user.update(column => info) if user.valid?
      { success: true, user: user, notice: "Connected #{column.capitalize} account." }
    end
  end

  def new_user
    user = find_or_create_user

    if user.valid?
      Role.create!(user_id: user.id, role: "Member")
      Settings.create!(user_id: user.id, active_roles: "Member")
      { success: true, user: user }
    else
      { success: false, alert: "Login failed." }
    end
  end

  def auth_type
    case @auth["provider"]
    when "google_oauth2"
      ["email", @auth["info"]["email"]]
    when "github"
      ["github_username", @auth["info"]["nickname"]]
    when "spotify"
      ["spotify_username", @auth["extra"]["raw_info"]["id"]]
    else
      [nil, nil]
    end
  end

  def find_or_create_user
    case @auth["provider"]
    when "google_oauth2"
      google_user
    when "github"
      github_user
    when "spotify"
      spotify_user
    end
  end

  def google_user
    email = @auth["info"]["email"]
    names = @auth["info"]["name"].to_s.split
    first_name = names[0].presence || "User"
    last_name = names[1..].join(" ").presence || ""

    User.find_or_create_by(email: email) do |user|
      user.first_name = first_name
      user.last_name = last_name
    end
  end

  def github_user
    github_username = @auth["info"]["nickname"]
    names = @auth["info"]["name"].to_s.split
    first_name = names[0].presence || "User"
    last_name = names[1..].join(" ").presence || ""

    User.find_or_create_by(github_username: github_username) do |user|
      user.first_name = first_name
      user.last_name = last_name
    end
  end

  def spotify_user
    spotify_username = @auth["extra"]["raw_info"]["id"]
    names = @auth["extra"]["raw_info"]["display_name"].to_s.split
    first_name = names[0].presence || "User"
    last_name = names[1..].join(" ").presence || ""

    User.find_or_create_by(spotify_username: spotify_username) do |user|
      user.first_name = first_name
      user.last_name = last_name
    end
  end
end
