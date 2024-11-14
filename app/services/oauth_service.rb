# Handles OAuth connection and user management.
#
# @attr [Hash] auth stores information retrieved after oauth call
# @attr [Integer] user_id stores user id of verifying user
class OauthService
  # This method initializes oauth object
  #
  # @param [Hash] auth of user details
  # @param [Integer] user_id of verifying user.
  def initialize(auth, user_id = nil)
    @auth = auth
    @user_id = user_id
  end

  # This method allows for connection and login with same service.
  #
  # @return [Method] existing_user (to allow for connecting various accounts)
  # @return [Method] new_user (to allow for login)
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
      { success: true, user: user, notice: "Connected #{column.split('_').first.capitalize} account." }
    end
  end

  def new_user
    user = find_or_create_user
    
    if user.valid?
      init_new_user(user.id)
      { success: true, user: user }
    else
      { success: false, alert: "Login failed." }
    end
  end

  def auth_type
    case @auth["provider"]
    when "google_oauth2"
      [ "email", @auth["info"]["email"] ]
    when "github"
      [ "github_username", @auth["info"]["nickname"] ]
    when "spotify"
      [ "spotify_username", @auth["extra"]["raw_info"]["id"] ]
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

    user = User.find_or_create_by(email: email) do |user|
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

  def init_new_user(user_id)
    user = User.find(user_id)
    if user.created_at == user.updated_at
      user.touch
      Role.create!(user_id: user.id, role: "Member")
      Settings.create!(user_id: user.id, active_roles: "Member")
    end
  end 
end
