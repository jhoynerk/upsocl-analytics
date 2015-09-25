ActiveAdmin.register Campaign do
  permit_params :name, :url, user_ids: [], urls_attributes: [ :id, :data, :_destroy ]

  show do
    panel 'Detalles de la Camapaña' do
      attributes_table_for campaign do
        row :id
        row :name
        row :urls do
          render 'url_list', urls: campaign.urls
        end
        row :users do
          campaign.join_users
        end
      end
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column(:users) do |c|
      c.join_users
    end
    actions
  end

  filter :name

  form do |f|
    f.inputs "Campaña" do
      f.input :name
      f.input :users, :as => :select, :input_html => {:multiple => true}
    end
    f.inputs do
      f.has_many :urls, heading: 'Direcciones Url', allow_destroy: true, new_record: 'Añadir' do |a|
        a.input :data, label: 'URL'
      end
    end
    f.actions
  end

end
