class Theme < ActiveRecord::Base
  store :settings, :accessors => [:color, :font, :menu_type]
  
  BOOTSTRAP_SETTINGS = {
      :links => {
          :linkColor => {:default => "#08c", :type => :color},
          :linkColorHover => {:default => "darken(@linkColor, 15%)", :type => :color}
      },
      :grays => {
          :black => "#000",
          :grayDarker => "#222",
          :grayDark => "#333",
          :gray => "#555",
          :grayLight => "#999",
          :grayLighter => "#eee",
          :white => "#fff"
      },
      :accent_colors => {
          :blue => "#049cdb",
          :blueDark => "#0064cd",
          :green => "#46a546",
          :red => "#9d261d",
          :yellow => "#ffc40d",
          :orange => "#f89406",
          :pink => "#c3325f",
          :purple => "#7a43b6"
      },
      :typography => {
          :baseFontSize => "13px",
          :baseFontFamily => "Helvetica Neue, Helvetica, Arial, sans-serif",
          :baseLineHeight => "18px",
          :textColor => "@grayDark"
      },
      :buttons => {
          :primaryButtonBackground => "@linkColor"
      },
      :placeholderText => "@grayLight",
      :hrBorder => "@grayLighter",
      :navbar => {
          :navbarHeight => "40px",
          :navbarBackground => "@grayDarker",
          :navbarBackgroundHighlight => "@grayDark",
          :navbarLinkBackgroundHover => "transparent",
          :navbarText => "@grayLight",
          :navbarLinkColor => "@grayLight",
          :navbarLinkColorHover => "@white"
      },
      :alert => {
          :warningText => "#c09853",
          :warningBackground => "#fcf8e3",
          :warningBorder => "darken(spin(@warningBackground, -10), 3%)",
          :errorText => "#b94a48",
          :errorBackground => "#f2dede",
          :errorBorder => "darken(spin(@errorBackground, -10), 3%)",
          :successText => "#468847",
          :successBackground => "#dff0d8",
          :successBorder => "darken(spin(@successBackground, -10), 5%)",
          :infoText => "#3a87ad",
          :infoBackground => "#d9edf7",
          :infoBorder => "darken(spin(@infoBackground, -10), 7%)"
      },
      :grid => {
          :gridColumns => "12",
          :gridColumnWidth => "60px",
          :gridGutterWidth => "20px",
          :gridRowWidth => "(@gridColumns * @gridColumnWidth) + (@gridGutterWidth * (@gridColumns - 1))",
          :fluidGridColumnWidth => "6.382978723%",
          :fluidGridGutterWidth => "2.127659574%"
      }
  }
  attr_accessible :name
  
  has_many :sites, :dependent => :nullify
  has_many :theme_assets, :dependent => :destroy
  document_accessor :document

  delegate :size, :mime_type, :url, :width, :height, :ext, :uid, :to => :document
  after_save :install_theme
  after_save :fire_update_in_sites

  before_validation do |r|
    r.name = CGI::unescape(document_name.to_s).gsub(/\.\w+$/, '') unless r.name.present?
    r.name.parameterize("-") # include in url !!!!
  end

  validates_property :mime_type, :of => :document, :in => %w(application/zip),
                     :message => :incorrect_document_type

  validates :name, :presence => true,
            :uniqueness => true,
            :length => {:maximum => 100}


  def themes_folder
    File.join(Rails.root, 'tmp', 'themes', id.to_s)
  end

  def install_theme
    return unless document.present?
    source = File.join(document.app.datastore.configuration[:root_path], uid)
    tmp_path = File.join(Rails.root, 'tmp', 'themes')
    tmp_theme_path = File.join(Rails.root, 'tmp', 'themes', name)
    public_path = File.join(Rails.public_path, Rails.application.config.assets.prefix, 'themes', name)
    app_path = File.join(Rails.root, 'app', 'assets')

    begin
      ::Gko::FileUtilz.unzip_file(source, tmp_path)
    rescue Exception => e
      self.errors.add :base, "Impossible de décompresser le dossier: \n:" + e
    end

    uncompiled_path = File.join(tmp_theme_path, "uncompiled")
    compiled_path = File.join(tmp_theme_path, "compiled")

    if File.exists?(compiled_path) && File.exists?(uncompiled_path)
      begin
        #if Rails.development?
        #p "Moving uncompiled files from #{uncompiled_path} to #{app_path}" 
        #::Gko::FileUtilz.mirror_files(uncompiled_path, app_path) # move to assets path
        #elsif
        Rails.logger.info "Moving compiled files from #{compiled_path} to #{public_path}"
        dir = Pathname.new(public_path) if public_path.is_a?(String)
        dir.rmtree if dir.directory?
        FileUtils.mkdir_p(dir)
        ::Gko::FileUtilz.mirror_files(compiled_path, public_path) # move to public path
                                                                  #end
      rescue Exception => e
        self.errors.add :base, "Impossible de déplacer le dossier \n:" + e
      end
    else
      self.errors.add :base, "Les dossiers 'uncompiled' ou/et 'compiled' sont introuvables dans #{tmp_theme_path}"
    end
  end

  def write_css
    #Creates a directory and all its parent directories
    stylesheets_path = File.join(themes_folder, "stylesheets")
    FileUtils.mkdir_p(stylesheets_path)

    File.open(File.join(stylesheets_path, 'public.css.scss'), 'w') do |f|
      f.puts "$bodyBackgroundColor: #E9E8E8;@import 'gko_public_all';"
    end
  end

  def activate!
    update_attribute(:active, true)
  end

  def deactivate!
    update_attribute(:active, false)
  end

  def load_yml
    #http://stackoverflow.com/questions/5100509/rails-read-the-file-and-store-the-database
    #APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/bootstrap.yml")[RAILS_ENV]
  end

  def write_yml
    #a_config = YAML.load_file "#{RAILS_ROOT}/config/application.yml"
    #a_config["user"]["pwd_days"] = params[:days]
    #File.open("#{RAILS_ROOT}/config/application.yml", 'w') { |f| YAML.dump(a_config, f) }
  end

  def css
    s = ""
    theme.settings.each_pair do |key, value|
      s += "#{key} #{value};\n"
    end
    s
  end

  private
  def fire_update_in_sites
    #self.sites.each do |site|
    #  ::SiteSweeper.instance.after_update(site)
    #end
  end

end