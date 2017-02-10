json.extract! formulario, :id, :name, :last_name, :email, :address, :path_url, :created_at, :updated_at
json.url form_url(formulario, format: :json)
