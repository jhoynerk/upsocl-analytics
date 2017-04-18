ActiveAdmin.register Agency do
  permit_params :name
  menu parent: "Utilidad"
  filter :name
end
