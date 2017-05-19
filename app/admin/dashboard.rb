ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }
  content title: proc { I18n.t("active_admin.dashboard") } do
    tabs do
      tab 'Activos' do
        render partial: "admin/dashboard/article_summary", locals: { articles: Url.status_active, videos: FacebookPost.urls.currents }
      end

      tab 'Completados' do
        render partial: "admin/dashboard/article_summary", locals: { articles: Url.status_finished, videos: FacebookPost.urls.recently_done }
      end
    end
  end

end
