# Arcade Development Guide

## 1. Open Command Prompt and Navigate to the Desired Folder Location

1. **Git**: [Download and install Git](https://git-scm.com/downloads).
2. Clone the repository:
   - **Using SSH**: `git clone git@github.com:tamu-edu-students/csce600-arcade.git`
     - [Help connecting via SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
   - **Using HTTPS**: `git clone https://github.com/tamu-edu-students/csce600-arcade.git`
     - [Help cloning via HTTPS](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository#cloning-a-repository-using-https)

---

## 2. Environment Setup

- **For Windows Users**: [Install WSL](https://learn.microsoft.com/en-us/windows/wsl/install)
- **For Mac Users**: Use Terminal directly.

> **Warning**  
> Activate WSL: `wsl`

---

## 3. Ruby Installation

1. Install `rbenv`: `sudo apt install rbenv`
2. Install Ruby: `rbenv install 3.3.5`

> **Warning**  
> If Ruby installation fails:  
> `git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build`  
>  
> For Mac users, do not delete the preinstalled System Ruby version. Ensure your PATH contains the `rbenv` Ruby version before the system version in your bash file.  
> [Help managing Ruby version on Mac](https://dev.to/sarahcssiqueira/managing-ruby-versions-on-macos-apple-silicon-with-rbenv-1mon).

---

## 4. Dependencies

1. Install Bundler: `gem install bundler`
2. Install Gems: `bundle install`

> **Warning**  
> If step 2 fails: `bundle config set --local without 'production'`

3. Install additional packages:  
   `apt install libffi-dev libyaml-dev ruby-railties`
4. If Bundler uses the wrong Ruby version:  
   `export PATH="$HOME/.rbenv/bin:$PATH" && eval "$(rbenv init -)"`

---

## 5. Environment Variables

1. Create a `.env` file in the project root: `touch .env`
2. **GitHub OAuth**:
   - Go to [GitHub Developer Settings](https://github.com/settings/developers).
   - Create new OAuth application.
   - Include both the Heroku deployment URI and localhost URI in the Redirect URI section.
   - Add the following environment variables:
     - `GITHUB_CLIENT_ID`
     - `GITHUB_CLIENT_SECRET`
   - [Help creating OAuth apps](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps)

3. **Spotify OAuth**:
   - Go to [Spotify Developer Page](https://developer.spotify.com/documentation/web-api/concepts/authorization).
   - Set up the application and add both Heroku and localhost URIs.
   - Add the following environment variables:
     - `SPOTIFY_CLIENT_ID`
     - `SPOTIFY_CLIENT_SECRET`

4. **Google OAuth**:
   - Go to [Google Cloud Console](https://developers.google.com/identity/protocols/oauth2).
   - Set up the application and add both Heroku and localhost URIs.
   - Add the following environment variables:
     - `GOOGLE_CLIENT_ID`
     - `GOOGLE_PROJECT_ID`
     - `GOOGLE_CLIENT_SECRET`
     - `GOOGLE_AUTH_URI`
     - `GOOGLE_TOKEN_URI`
     - `GOOGLE_AUTH_PROVIDER`
     - `GOOGLE_REDIRECT_URIS`

---

## 6. Database Setup

1. Migrate: `rails db:migrate`
2. Seed: `rails db:seed`

> **Info**  
> The initial seed process may take up to 2 minutes.

---

## 7. Development Mode

1. Run the app: `rails server`
2. Access the app at:
   - [http://127.0.0.1:3000](http://127.0.0.1:3000)
   - [http://localhost:3000](http://localhost:3000)
3. Quit the app: Press `CTRL+C` in the terminal.

---

## 8. Run Tests and Coverage Report Locally

1. **Unit and Functional Tests**: `bundle exec rspec`
2. **Integration Tests**: `bundle exec cucumber`
3. **View Coverage Report**: `open coverage/index.html`

> **Warning**  
> If RSpec fails due to migrations: `RAILS_ENV=test rails db:migrate`

---

## 9. Run Tests and Coverage Report on GitHub

1. Run the "Tests and Coverage" workflow in the left navigation bar.
   - [Help running GitHub Actions](https://docs.github.com/en/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/manually-running-a-workflow)

---

## 10. Generate Developer Documentation

1. **Locally**:
   - Generate: `yard doc`
   - View: `open doc/index.html`
2. **On GitHub**:
   - Run the "Deploy Developer Docs" workflow.
   - View documentation [here](https://tamu-edu-students.github.io/csce600-arcade/).

---

## 11. Deployment (Heroku)

1. [Create a Heroku account](https://signup.heroku.com/).
2. [Install Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli).
3. Login: `heroku login`
4. Create a `Procfile` in the project root:  `web: bundle exec rails server -p $PORT`
5. Create Heroku app: `heroku create app-name`
6. Push your app: `git push heroku prod`
7. Database setup:  
`heroku run rails db:migrate && rails db:seed`
8. Set environment variables:
- CLI Command: `heroku config:set VAR_NAME=value`
- [Help setting config vars](https://devcenter.heroku.com/articles/config-vars)
- Add `TZ=America/Chicago` for time zone configuration.

> **Warning**  
> Add Heroku Postgres add-on before running database setup commands.

---

## 12. Enjoy Arcade!

