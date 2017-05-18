ActiveAdmin.register Url do
  filter :title, label: 'Nombre del articulo', as: :select, input_html: { class: 'chosen-input' }
  filter :campaign, label: 'Nombre de la compaña', as: :select, input_html: { class: 'chosen-input' }
  menu label: 'Artículos', parent: "Gestor de Campañas"

  config.clear_action_items!

  action_item :only => :index do
    link_to "Añadir Articulo" , new_admin_url_path
  end

  permit_params  :campaign_id, :title, :id, :publication_date,
  :committed_visits, :publication_end_date, :data, :publicity, :screenshot, :line_id,
  :_destroy, :profile_id, :interval_status, :country_ids=> [],
  :tag_ids=> [], facebook_posts_attributes: [ :id, :post_id, :facebook_account_id, :original, :_destroy ]

  analytics = [ ["www.cutypaste.com", "41995195"],
      ["All Web Site Data", "70319478"],
      ["Cutypaste Vitrina", "95335599"],
      ["Upsocl Network", "92974712"],
      ["Upsocl Branded", "111669814"],
      ["Upsocl + CK2", "118766523"] ]

  show title: 'Detalles del artículo' do |url|
    panel 'Detalles' do
      attributes_table_for url do
        row :title
        row "campaña" do |u|
           u.campaign_name
        end
      end
    end
  end

  index title: 'Articulos' do |url|
    selectable_column
    id_column
    column :title
    column 'Campaña', sortable: 'campaign_id' do |u|
      u.campaign_name
    end
    column() {|u| link_to('Editar', edit_admin_url_path(u))}
    column() {|u| link_to('Actualizar Metricas', update_metrics_admin_url_path(u), method: :post)}
    column() {|u| link_to('Detalle Estadísticas', details_admin_url_path(u), method: :post)}
  end

  form do |f|
    f.inputs "Articulo" do
      li "Título: #{f.object.title}" if f.object.title
      li "Campaña Actual: #{f.object.campaign_name}" if f.object.campaign_name
      f.input :campaign_id, label: 'Campaña Nueva', as: :select, collection: Campaign.all.map{ |a| [ "#{a.name}", f.id] }, input_html: { class: 'chosen-input'}
      f.input :data
      f.input :screenshot
      f.input :publication_date, as: :datepicker
      f.input :publication_end_date, as: :datepicker
      f.input :committed_visits, as: :number
      f.input :line_id, :input_html => { :type => 'text' }
      f.input :publicity, label: 'Con publicidad'
      f.input :countries, :as => :select, :input_html => {:multiple => true, :class => "chosen-input"}, label: 'Paises'
      f.input :tags, :as => :select, collection: Tag.type_tag_sub_category.to_a, :input_html => {:multiple => true, :class => "chosen-input", 'data-maxselected' => 2 }, label: 'Sub-Categoría'
      f.input :tags, :as => :select, collection: Tag.type_tag_type_content.to_a, :input_html => {:multiple => true, :class => "chosen-input", 'data-maxselected' => 3 }, label: 'Tipo de Contenido'
      f.input :tags, :as => :select, collection: Tag.type_tag_tone.to_a, :input_html => {:multiple => true, :class => "chosen-input", 'data-maxselected' => 2 }, label: 'Tono'
      f.input :tags, :as => :select, collection: Tag.type_tag_format.to_a, :input_html => {:multiple => true, :class => "chosen-input", 'data-maxselected' => 1 }, label: 'Formato'
      f.input :profile_id, label: 'Account Analytics', as: :select, collection: analytics, input_html: { class: 'chosen-input'}
      f.has_many :facebook_posts, heading: 'Post Facebook asociados', allow_destroy: true, new_record: 'Añadir Post Facebook' do |e|
        e.input :post_id, label: 'ID del post de facebook'
        e.input :facebook_account, :as => :select, :input_html => { :class => "chosen-input"}
        e.input :original, label: 'Original'
      end
    end
    f.actions
  end

  member_action :update_metrics, method: :post do
    url = Url.find(params[:id])
    url.run_analytics_task
    if AnalyticFacebook.new(url).save
      redirect_to resource_path(url), notice: "facebook actualizado, analytics se ha puesto en la cola de tareas"
    else
      redirect_to resource_path(url), notice: "facebook no se ha actualizado"
    end
  end

  member_action :details, method: :post do
    @url = resource
    @country = params[:country]
    @countries = @url.country_stadistics.country_select_collection
    @country_stadistics = @url.country_stadistics.by_country(@country).order(date: :desc)
    @page_title = "Estadísticas para articulo: #{resource.title}"
  end



end
