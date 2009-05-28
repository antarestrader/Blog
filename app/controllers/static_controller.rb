class StaticController < Application
  
  def show
    "Static Page for #{params[:page]}"
  end

end
