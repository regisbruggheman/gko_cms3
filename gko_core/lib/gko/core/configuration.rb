module Gko
  module Core
    include ActiveSupport::Configurable

    config_accessor :rescue_not_found,
                    :s3_backend,
                    :admin_precompile, 
                    :admin_table_css, 
                    :reserved_subdomains, 
                    :dragonfly_secret, 
                    :trust_file_extensions,
                    :page_types,
                    :layout_template_whitelist,
                    :view_template_whitelist, 
                    :use_layout_templates,
                    :use_view_templates,
                    :allow_video_on_images
                    
    self.rescue_not_found = true #Rails.env.production? 
    self.s3_backend = false
    self.admin_table_css = 'table table-striped table-bordered table-condensed'
    self.dragonfly_secret = Array.new(24) { rand(256) }.pack('C*').unpack('H*').first
    self.trust_file_extensions = false
    self.reserved_subdomains = %w{www ftp mail admin email blog webmail support help site sites}
    self.page_types = Gko::PageTypes.registered
    self.layout_template_whitelist = ["application"]
    self.view_template_whitelist = ["home", "show"]
    class << self
      def layout_template_whitelist
        Array(config.layout_template_whitelist).map(&:to_s)
      end
      def view_template_whitelist
        Array(config.view_template_whitelist).map(&:to_s)
      end
    end
    self.use_layout_templates = false
    self.use_view_templates = false
    self.allow_video_on_images = false
    self.admin_precompile = [
        "gko_admin_all.js",
        "gko_public_all.js",
        "gko/admin/admin.js",
        "gko/admin/tree-reorder.js",
        "wymeditor/lang/fr.js",
        "wymeditor/lang/en.js",
        "wymeditor/skins/gko/skin.js",
        "gko-codemirror-all.js",
        "gko_admin_all.css",
        "gko_print.css",
        "gko_wym.css",
        "wymeditor/skins/gko/skin.css",
        "wym_iframe.css",
        "wym_formatting.css",
        "wym_theme.css",
        "gko-codemirror-all.css"
    ]
  end
end
