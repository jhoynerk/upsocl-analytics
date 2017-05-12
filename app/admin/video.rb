ActiveAdmin.register FacebookPost do
  scope "Videos", :urls, default: true
  actions :index, :edit, :update
  menu label: 'Video', parent: "Gestor de Comapañas"

  config.clear_action_items!
  permit_params  :campaign_id

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
      li "Título: #{f.object.title}"
      li "Campaña Actual: #{f.object.campaign.name}"
      f.input :campaign_id, label: 'Campaña Nueva', as: :select, collection: Campaign.all.map{ |a| [ "#{a.name}", a.id] }, input_html: { class: 'chosen-input'}
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
