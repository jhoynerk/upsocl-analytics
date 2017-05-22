ActiveAdmin.register FacebookAccount do
  menu parent: "Ajustes"
  permit_params :name, :facebook_id
  config.clear_sidebar_sections!

  form do |f|
    f.inputs "Facebook Account" do
      f.input :name, label: "Nombre usuario"
      f.input :facebook_id, label: "ID cuenta Facebook"
    end
    f.actions
  end
end
