ActiveAdmin.register Reaction do
  permit_params :title, :avatar
  menu parent: "Ajustes"

  index do
    selectable_column
    id_column
    column :title
    actions
  end

  form do |f|
    f.inputs "Información Reacción" do
      f.input :title
      f.input :avatar
    end
    f.actions
  end
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
