ActiveAdmin.register Agency do
  permit_params :name
  menu parent: "Utilidad"
  filter :name, label: 'Nombre', as: :select, input_html: { class: 'chosen-input' }

  controller do
    def destroy
      destroy! do |success, failure|
        failure.html do
          flash[:error] = "Mensaje: " + resource.errors.full_messages.to_sentence
          render action: :index
        end
      end
    end
  end
end
