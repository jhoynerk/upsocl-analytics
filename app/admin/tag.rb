ActiveAdmin.register Tag do
  menu parent: "Ajustes"
  permit_params :title, :type_tag

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Cliente / Marcas" do
      f.input :title
      f.input :type_tag, :as => :select, collection: TagType.to_a, :input_html => { :class => "chosen-input"}, label: "Tipo de Etiqueta"
    end

    f.actions
  end

end
