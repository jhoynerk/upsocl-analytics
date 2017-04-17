ActiveAdmin.register Mark do
  permit_params :name, countries_marks_attributes: [ :id, :country_id, :mark_id, :_destroy, agencies_countries_marks_attributes: [ :id, :agency_id, :countries_mark_id, :_destroy, campaign_ids: [] ] ]
  menu parent: "Utilidad"
  agencies = Agency.all.select(:name, :id )
  campaigns = Campaign.all.select(:name, :id)

  filter :name
  filter :countries, label: 'Países', as: :select, collection: proc { Country.in_mark }, input_html: { class: 'chosen-input select_search'}
  filter :countries_marks, label: 'Marcas Países', as: :select, collection: proc { CountriesMark.all.map{|cm| ["#{cm.content_search}", cm.id]} }, input_html: { class: 'chosen-input select_search'}
  # show
  show do |marks|
    panel 'Detalles del Cliente / Marca' do
      attributes_table_for marks do
        row :id
        row :name
        row :paises do
          render 'countries_marks', countries_marks: marks.countries_marks
        end
      end
    end
  end

  # create and update
  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Cliente / Marcas" do
      f.input :name
    end
    f.inputs do
      f.has_many :countries_marks, heading: 'Países', allow_destroy: true, new_record: 'Añadir País' do |a|
        a.input :country, :as => :select, :input_html => { :class => "chosen-input"}, label: "País"
        a.has_many :agencies_countries_marks, heading: 'Agencias', allow_destroy: true, new_record: 'Añadir Agencia', class: 'agencies_countries_panel' do |b|
          b.input :agency_id, label: 'Agencia', as: :select, collection: agencies, input_html: { class: 'chosen-input select_agencia'}
          b.input :campaign_ids, label: 'Campaña', as: :select, collection: campaigns.map{|c| ["#{c.name} [#{c.id}]", c.id]} , input_html: { :multiple => true, class: 'chosen-input'}
        end
      end
    end


    f.actions
  end
end
