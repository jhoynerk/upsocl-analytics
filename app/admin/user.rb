ActiveAdmin.register User do
  permit_params :email, :name, :password, :password_confirmation, :role, campaign_ids: []

  controller do
    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end
  end

  show do
    panel 'Detalles de Usuario' do
      attributes_table_for user do
        row :id
        row :name
        row :role
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
    column :role
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
      f.input :role
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
