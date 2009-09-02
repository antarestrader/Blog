class AdminController < Application
  
  before :ensure_authenticated
  
  before do
    @posts_availible = Post.all(domain_finder)
  end

  def index
    @drafts = @posts_availible.drafts
    @pending = @posts_availible.pending
    render
  end
  
  def backup
    provides :xml
    @posts=Post.all
    render
  end
  
  def restore
    if params[:file]
      confirm_restore
    elsif params[:restore_file]
      exicute_restore
    else
      backup_error("Request did not contain a file")
    end
  end
  
private
  
  def confirm_restore
    FileUtils.mv(params[:file][:tempfile].path, Merb.root / "tmp/")
    @filename = File.basename(params[:file][:tempfile].path)
    @restore = Restore.new(params[:file][:tempfile])
    @restore.domain = params[:restore_domain] unless params[:restore_domain].nil? || params[:restore_domain].empty?
    render
  end
  
  def exicute_restore
    filename = Merb.root / "tmp"/ params[:restore_file]
    file = File.open(filename)
    File.unlink(filename)
    return redirect url(:backup) unless params[:submit] == 'Restore'
    @restore = Restore.new(file)
    if @restore.run!
      message[:notice] = "Backup Restored Successfully"
      redirect url(:home)
    else
      backup_error("File could not be read")
    end
  end
  
  def backup_error(msg)
    response.status = 406
    message[:error] = msg 
    render(:template=>'admin_controller/backup')
  end
  

  
end
