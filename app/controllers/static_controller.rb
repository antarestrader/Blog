class StaticController < Application
  
  def show
    @page = params[:page].gsub(/[^\w]/,'') #make it safe
    begin
      render(:template=>"static/#{@page}",:layout=>false)
    rescue TemplateNotFound
      self.status = 404
      render(:template=>"static/404")
    end
  end

end
