ActiveAdmin.register Mark do
  permit_params :name, countries_marks_attributes: [ :country_id, agencies_countries_marks: [ :agency_id ] ]
  menu parent: "Utilidad"

  form do |f|
    f.inputs "Cliente / Marcas" do
      f.input :name
    end
    f.inputs do
      f.has_many :countries_marks, heading: 'Países', allow_destroy: true, new_record: 'Añadir País' do |a|
        a.input :country, :as => :select, :input_html => { :class => "chosen-input"}, label: "País"
        a.has_many :agencies_countries_marks, heading: 'Agencias', allow_destroy: true, new_record: 'Añadir Agencia', class: 'panel_urls' do |b|
          b.input :agencies, :as => :select, :input_html => { :multiple => false, :class => "chosen-input"}, label: 'Agencia'
          b.input :campaigns, :as => :select, :input_html => {:multiple => true, :class => "chosen-input"}
        end
      end
    end


    f.actions
  end
end
