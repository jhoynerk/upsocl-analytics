ActiveAdmin.register Url do
  filter :title
  filter :campaign
  menu label: 'Artículos'
  config.clear_action_items!
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
    column() {|u| link_to('Detalle Estadísticas', details_admin_url_path(u), method: :post)}
  end

  form do |f|
    f.inputs "Articulo" do
      li "Título: #{f.object.title}"
      li "Campaña Actual: #{f.object.campaign_name}"
      f.input :campaign_id, label: 'Campaña Nueva', as: :select, collection: Campaign.all.map{ |a| [ "#{a.name}", a.id] }, input_html: { class: 'chosen-input'}
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
    @countries = @url.country_stadistics.countries_for_select
    @country_stadistics = @url.country_stadistics.by_country(@country)
    @page_title = "Estadísticas para articulo id: #{resource.id}"
  end



end
