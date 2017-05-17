ActiveAdmin.register Tag do
  menu parent: "Ajustes"
  permit_params :title, :type_tag

  filter :title, label: 'Nombre del articulo', as: :select, input_html: { class: 'chosen-input' }
  filter :type_tag, label: 'Tipo', as: :select, collection: proc { TagType.to_a }, input_html: { :multiple => true, class: 'chosen-input select_search'}

  index do
    selectable_column
    column :id
    column :title
    column(:type_tag) do |u|
      u.type_tag_humanize
    end
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Etiquetas" do
      f.input :title
      f.input :type_tag, :as => :select, collection: TagType.to_a, :input_html => { :class => "chosen-input"}, label: "Tipo de Etiqueta"
    end

    f.actions
  end

end
