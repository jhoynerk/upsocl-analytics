ActiveAdmin.register FacebookPost do
  scope "Videos", :urls, default: true
  actions :index, :edit, :update, :new, :create
  menu  label: 'Video', parent: "Gestor de Campañas"

  config.clear_action_items!

  action_item :only => :index do
    link_to "Añadir Video" , new_admin_facebook_post_path
  end

  filter :title, as: :select, input_html: { class: 'chosen-input' }

  permit_params  :campaign_id, :title, :post_id, :url_video, :goal,
                 :facebook_account_id, :tag_ids=> []

  index title: 'Videos' do
    selectable_column
    id_column
    column 'Titulo', :title
    column 'Campaña', :campaing do |fbp|
      fbp.campaign.name
    end
    column 'Canal', :account do |fbp|
      fbp.facebook_account.name
    end
    column 'Personas Alcanzadas', :post_impressions_unique
    column 'Reproducciones', :post_video_views
    column() {|u| link_to('Editar', edit_admin_facebook_post_path(u))}
    column() {|u| link_to('Actualizar Metricas', update_metrics_admin_facebook_post_path(u), method: :post)}
  end

  form do |f|
    f.inputs "Video" do
      li "Título: #{f.object.title}" if f.object.title
      li "Campaña Actual: #{f.object.campaign.name}" if f.object.campaign
      f.input :campaign_id, label: 'Campaña Nueva', as: :select, collection: Campaign.all.map{ |a| [ "#{a.name}", a.id] }, input_html: { class: 'chosen-input'}
      f.input :title
      f.input :url_video
      f.input :goal
      f.input :facebook_account, :as => :select, :input_html => { :class => "chosen-input"}
      f.input :tags, :as => :select, collection: Tag.type_tag_sub_category.to_a, :input_html => {:multiple => true, :class => "chosen-input", 'data-maxselected' => 2 }, label: 'Sub-Categoría'
      f.input :tags, :as => :select, collection: Tag.type_tag_type_content.to_a, :input_html => {:multiple => true, :class => "chosen-input", 'data-maxselected' => 3 }, label: 'Tipo de Contenido'
      f.input :tags, :as => :select, collection: Tag.type_tag_tone.to_a, :input_html => {:multiple => true, :class => "chosen-input", 'data-maxselected' => 2 }, label: 'Tono'
      f.input :tags, :as => :select, collection: Tag.type_tag_format.to_a, :input_html => {:multiple => true, :class => "chosen-input", 'data-maxselected' => 1 }, label: 'Formato'

    end
    f.actions
  end

  member_action :update_metrics, method: :post do
    facebook_post = FacebookPost.find(params[:id])
    if facebook_post.save
      redirect_to collection_path, notice: "Proceso de actualización de metricas iniciado."
    else
      redirect_to collection_path, alert: "#{facebook_post.errors.full_messages}"
    end
  end

end
