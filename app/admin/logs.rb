ActiveAdmin.register_page "Logs" do

  content title: 'Logs' do
    columns do
      column do
        panel "Ultimos 15 Mensajes de Actualización del Servidor Analytics" do
          ul do
            Message.where(type_update: 1).order(:id => :desc).limit(15).map do |message|
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
      column do
        panel "Ultimos 15 Mensajes de Actualización del Servidor Facebook" do
          ul do
            Message.where(type_update: 2).order(:id => :desc).limit(15).map do |message|
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
      column do
        panel "Exportar a XLS" do
          render 'consult_data'
        end
      end
    end
  end

end
