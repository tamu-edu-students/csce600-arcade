OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:google_oauth2, {
  'provider' => 'google_oauth2',
  'uid' => '1',
  'info' => {
    'name' => 'Test User',
    'email' => 'test_email@tamu.edu'
  }
})
