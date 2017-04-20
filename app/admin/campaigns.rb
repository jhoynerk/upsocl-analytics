ActiveAdmin.register Campaign do
  permit_params :name, :agencies_countries_mark_id, :url, user_ids: [], urls_attributes: [ :id, :status, :committed_visits, :data, :publicity, :screenshot, :line_id, :_destroy, :profile_id, :interval_status, :country_ids=> [], :tag_ids=> [] , facebook_posts_attributes: [ :id, :post_id, :facebook_account_id, :_destroy ] ]

  analytics = [ ["www.cutypaste.com", "41995195"],
      ["All Web Site Data", "70319478"],
      ["Cutypaste Vitrina", "95335599"],
      ["Upsocl Network", "92974712"],
      ["Upsocl Branded", "111669814"],
      ["Upsocl + CK2", "118766523"] ]



  show do
    panel 'Detalles de la Campaña' do
      attributes_table_for campaign do
        row :id
        row :name
        row "Marca / País / Agencia" do
          campaign.agencies_countries_mark.full_info unless campaign.agencies_countries_mark.nil?
        end
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
    f.semantic_errors *f.object.errors.keys
    f.inputs "Campaña" do
      f.input :name
      f.input :agencies_countries_mark_id, label: 'Cliente / País / Agencia', as: :select, collection: AgenciesCountriesMark.all.map{ |a| [ "#{a.full_info}", a.id] }, input_html: { class: 'chosen-input'}
      f.input :users, :as => :select, :input_html => {:multiple => true, :class => "chosen-input"}
    end
    f.inputs do
      f.has_many :urls, heading: 'Posts', allow_destroy: true, new_record: 'Añadir', class: 'panel_urls' do |a|
        a.input :data
        a.input :screenshot
        a.input :status, as: :radio
        a.input :committed_visits, as: :number
        a.input :line_id, :input_html => { :type => 'text' }
        a.input :publicity, label: 'Con publicidad'
        a.input :countries, :as => :select, :input_html => {:multiple => true, :class => "chosen-input"}, label: 'Paises'
        a.input :tags, :as => :select, :input_html => {:multiple => true, :class => "chosen-input"}, label: 'Etiquetas'
        a.input :profile_id, label: 'Account Analytics', as: :select, collection: analytics, input_html: { class: 'chosen-input'}
        a.input :interval_status, label: 'Frecuencia de actualización', as: :select, collection: IntervalStatus.to_a, input_html: { class: 'chosen-input' }
        a.has_many :facebook_posts, heading: 'Post Facebook asociados', allow_destroy: true, new_record: 'Añadir Post Facebook' do |e|
          e.input :post_id, label: 'ID del post de facebook'
          e.input :facebook_account, :as => :select, :input_html => { :class => "chosen-input"}
        end
      end
    end
    f.actions
  end

end
