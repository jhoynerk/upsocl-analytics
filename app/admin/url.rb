ActiveAdmin.register Url do
  require 'rake'
  UpsoclAnalytics::Application.load_tasks
  menu label: 'Artículos'
  permit_params  :campaign_id, :title
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
    column 'Campaña' do |u|
      u.campaign_name
    end
    column() {|u| link_to('Editar', edit_admin_url_path(u))}
    column() {|u| link_to('Actualizar Metricas', update_metrics_admin_url_path(u), method: :post)}
  end

  form do |f|
    f.inputs "Articulo" do
      li "Título: #{f.object.title}"
      f.input :campaign_id, label: 'Campaña', as: :select, collection: Campaign.all.map{ |a| [ "#{a.name}", a.id] }, input_html: { class: 'chosen-input'}
    end
    f.actions
  end

  member_action :update_metrics, method: :post do
    url = Url.find(params[:id])
    Delayed::Job.enqueue(DelayedRake.new("analytics:add_records", time: 'week', interval: 'day', url_id: url.id))
    #Rake.application.invoke_task("analytics:add_records['week','day',#{url.id}]")
    if AnalyticFacebook.new(url).save
      redirect_to resource_path(url), notice: "facebook actualizado, analytics tambien"
    else
      redirect_to resource_path(url), notice: "facebook no se ha actualizado"
    end
  end

end
