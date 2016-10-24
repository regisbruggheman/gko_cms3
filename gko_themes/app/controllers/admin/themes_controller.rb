class Admin::ThemesController < Admin::ResourcesController
  respond_to :html, :js, :json
  helper :themes
  #cache_sweeper ThemeSweeper, :only => [:update]
  custom_actions :resource => [:select, :unselect]
  before_filter :load_theme, :except => [:index, :new, :create]

  include ActionView::Helpers::SanitizeHelper

  def begin_of_association_chain;
    nil;
  end

  def index
    @theme = Theme.new
    @themes = Theme.all
    respond_with(:admin, @themes)
  end

  def new
    @theme = Theme.new
    respond_with(:admin, @theme)
  end

  def create
    @theme = Theme.create(params[:theme])
    respond_with(:admin, @theme)
  end

  #def edit
   # f = File.new("#{Gko.roots(Gko::Themes)}/config/bootstrap.less", "r").read
    # Remove extra wihte space
   # f = f.gsub(/ +/, ' ')
    # Remove comments
   # f = f.gsub(/((?:\/\*(?:[^*]|(?:\*+[^*\/]))*\*+\/)|(?:\/\/.*))/, '');
    # Remove breakline
   # f = f.gsub!("\n", "")
    # Remove unnecesairy whitespace
  #  f = f.gsub!(/\s*([{}|:;,])\s+/, '\1');

    # Remove unnecesairy ;'s
   # f = f.gsub!(/;}/, '}')
    # Uniformise
  #  f = f.gsub!("'", '"')
  #  f = f.gsub!(/&/, ' &')
  #  f = f.gsub!('{>', '{ >')
  #  f = f.gsub!(':#', ': #')

    #Rails.logger.info(f)
  #  @base_css = f
  #  @theme_definitions = YAML.load_file("#{Gko.roots(Gko::Themes)}/config/bootstrap.yml")
  #  respond_with(:admin, @theme, :layout => "theme_roller")
  #end
  
  def edit
    @theme = Theme.find(params[:id])
    respond_with(:admin, @theme)
  end

  def load
    begin
      f = File.new("#{Gko.roots(Gko::Themes)}/config/bootstrap.less", "r").read
      @base_css = f
    rescue
      raise "Unable to open file!"
    end
    @theme_definitions = YAML.load_file("#{Gko.roots(Gko::Themes)}/config/bootstrap.yml")
    render :js => @base_css, :layout => false
  end

  def update
    @theme.update_attributes(params[:theme])
    render :action => 'edit'
  end

  def show
    render :action => 'edit'
  end

  def destroy
    @theme.destroy
    respond_with(:admin, @theme, :location => admin_themes_path)
  end

  def select
    @theme.activate!
    respond_with(:admin, @theme, :location => admin_themes_path)
  end

  def unselect
    @theme.deactivate!
    respond_with(:admin, @theme, :location => admin_themes_path)
  end

  def preview
    respond_with(@theme, :layout => false)
  end

  def default
    respond_with(@theme, :layout => false)
  end

  protected

  def load_theme
    @theme = Theme.find(params[:id])
  end
end