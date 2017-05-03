ActiveAdmin.register User do
  permit_params :email, :name, :admin,:password, :password_confirmation, campaign_ids: []
  show do
    panel 'Detalles de Usuario' do
      attributes_table_for user do
        row :id
        row :name
        row :admin do
          t("#{user.admin}_value", scope: 'activerecord.attributes.user/admin')
        end
        row :campaigns do
          user.join_campaigns
        end
      end
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :current_sign_in_at
    column :created_at
    actions
  end

  filter :email
  filter :name
  filter :current_sign_in_at
  filter :created_at

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :name
      f.input :campaigns, :as => :select, :input_html => {:multiple => true, :class => "chosen-input"}
      f.input :admin
      f.input :role
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
