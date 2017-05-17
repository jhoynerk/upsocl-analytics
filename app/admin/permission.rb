ActiveAdmin.register ::ActiveAdmin::Permission do
  menu  priority: 6
  actions :index

  filter :state, as: :select, label: 'Estado', input_html: { class: 'chosen-input' }, collection: controller.resource_class.states

  filter :managed_resource_action_equals, as: :select,
    label: 'Acción', input_html: { class: 'chosen-input' },
    collection: -> do
      actions = ::ActiveAdmin::ManagedResource.uniq.order(:action).pluck(:action)
      actions.map! { |a| [t("actions.#{a}"), a] }
    end

  filter :managed_resource_class_name_equals, as: :select,
    label: 'Nombre', input_html: { class: 'chosen-input' },
    collection: -> do
      collection = ::ActiveAdmin::ManagedResource.uniq.order(:class_name).pluck(:class_name)
      collection.reject{|a| a.match('ActiveAdmin::Comment')}.map! do |c|
        c = c.constantize
        c.try(:model_name) ? [c.model_name.human, c] : [c, c]
      end
    end
  scope :all, default: true

  controller.resource_class.manageable_roles.each_key(&method(:scope))

  controller.resource_class.states.each_key do |state|
    batch_action state do |ids|
      resource_class.clear_cache
      resource_class.where(id: ids).update_all(state: resource_class.states[state])
      redirect_to :back, notice: t("views.permission.notice.state_changed", state: state)
    end
  end

  collection_action :reload, method: :post do
    ::ActiveAdmin::ManagedResource.reload
    redirect_to :back, notice: t("views.permission.notice.reloaded")
  end

  action_item :reload do
    link_to t("views.permission.action_item.reload"), reload_admin_active_admin_permissions_path, method: :post
  end

  includes :managed_resource

  index do
    selectable_column
    column :role
    column :state, sortable: 'state' do |record|
      status_tag(t("active_admin.batch_actions.labels.#{record.state}"), record.can? ? :ok : nil)
    end
    column :action, sortable: 'active_admin_managed_resources.action' do |record|
      t("actions.#{record.action}")
    end
    column :nombre, sortable: 'active_admin_managed_resources.class_name' do |record|
      c = record.class_name.constantize
      c.try(:model_name) ? c.model_name.human : c
    end
  end
end
