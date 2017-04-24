Apipie.configure do |config|
  config.validate = false
  config.app_name                = "Mehsosment"
  # config.api_base_url            = "/api"
  # config.doc_base_url            = "/apipie"
  config.doc_base_url            = "/apidoc"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
