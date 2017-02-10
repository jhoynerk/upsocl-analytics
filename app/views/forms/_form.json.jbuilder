json.extract! form, :name, :last_name, :email, :address, :path_url, :created_at, :updated_at
json.url form_url(form, format: :json)
