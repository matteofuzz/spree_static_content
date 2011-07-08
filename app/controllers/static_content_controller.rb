class StaticContentController < Spree::BaseController
  caches_page :show
  
  def show
    locale = params[:locale] ? params[:locale] : I18n.locale
    path = case params[:path]
    when Array
      '/' + params[:path].join("/")
    when String
      '/' + params[:path]
    when nil
      request.path
    end
    
    @page = Page.visible.find_by_slug_and_locale(path, locale)
    @page ||= Page.visible.find_by_slug_and_locale(path, I18n.default_locale)
    @page ||= Page.visible.find_by_slug(path)
    unless @page
      render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
    end
  end
  
  private
  
  def accurate_title
    @page ? @page.title : nil
  end
end

