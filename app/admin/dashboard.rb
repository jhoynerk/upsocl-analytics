ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }
  content title: proc { I18n.t("active_admin.dashboard") } do
    tabs do
      tab 'Activos' do
        render partial: "admin/dashboard/article_summary", locals: { articles: Url.active, videos: FacebookPost.urls.active }
      end

      tab 'Completados' do
        render partial: "admin/dashboard/article_summary", locals: { articles: Url.finished, videos: FacebookPost.urls.finished }
      end
    end
  end

end
