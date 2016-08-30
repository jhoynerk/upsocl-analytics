ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    columns do
      column do
        panel "Ultimos 10 Mensajes de Actualización del Servidor Analytics" do
          ul do
            Message.where(type_update: 1).order(:id => :asc).limit(10).reverse.map do |message|
              case message.status
              when 1
                li class: 'flash flash_warning' do
                  message.message
                end
              when 2
                li class: 'flash flash_notice' do
                  message.message
                end
              when 3
                li class: 'flash flash_error' do
                  message.message
                end
              end
            end
          end
        end
        panel "Ultimos 10 Mensajes de Actualización del Servidor Facebook" do
          ul do
            Message.where(type_update: 2).order(:id => :asc).limit(10).reverse.map do |message|
              case message.status
              when 1
                li class: 'flash flash_warning' do
                  message.message
                end
              when 2
                li class: 'flash flash_notice' do
                  message.message
                end
              when 3
                li class: 'flash flash_error' do
                  message.message
                end
              end
            end
          end
        end
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
