cd ~/Github/gko_cms3
bundle install
rails s

cd ~/Github/gko_cms3
git tag -a v0.8.43 -m 'v0.8.43 Stable'
git push --tags

git tag -d v0.5.57

git branch -m 0.6.24-stable master

git branch -m master master-old
git push origin :master
git push origin master-old
git checkout -b master 0.6.24-stable
git push origin master


warn "[DEPRECATION] `useless` is deprecated.  Please use `useful` instead."


remove cache directory

rm -rf ~/.bundle/ ~/.gem/
rm -rf $GEM_HOME/bundler/ $GEM_HOME/cache/bundler/
rm -rf .bundle/
rm -rf vendor/cache/
rm -rf Gemfile.lock
bundle install

#############################################
GENERATE A NEW APP AND RUN IT:

cd ~/Github/gko_cms3
bundle install
thor gko:app myapp_com --target ~/Github -force true --migrate false
cd ~/developer/workspace/gko_myapp_com
bundle install
bundle exec rake gko:install

capify .

#set default locale to something other than :en in initializers/locale.rb
#set environment/production config.serve_static_assets = true

bundle exec rake gko:seed
rails s



Now in your browser navigate to http://localhost:3000. Fill out the fields in the resulting page and click 'Create Site'. After this you can log in to your new site with the credentials 'admin@admin.org' and password 'admin!'.
#############################################



http://apidock.com/rails/ActiveRecord/Base/unscoped/class

http://www.alfajango.com/blog/rails-3-remote-links-and-forms/

https://github.com/msales/multisite_action_mailer

namespace :deploy do
 desc "Create asset packages for production"
 task :after_update_code, :roles => [:web] do
   run <<-EOF
     cd #{release_path} && rake asset:packager:build_all
   EOF
 end
end

------------------------------------
LOCALES_PATH  = "#{Rails.root}/config/locales/*.yml"
MASTER_LOCALE = "#{Rails.root}/config/locales/en.yml"

class Hash
  def to_yaml( opts = {} )
    YAML::quick_emit( object_id, opts ) do |out|
      out.map( taguri, to_yaml_style ) do |map|
        sort.each do |k, v| # "sort" added
          map.add( k, v )
        end
      end
    end
  end
end

------------------------------------
#### RVM #########################################


CSS EMAIL
http://www.campaignmonitor.com/css/
http://sendgrid.com/pricing.html

Liquid Email
http://www.campaignmonitor.com/
http://cjohansen.no/en/rails/liquid_email_templates_in_rails
http://mailchimp.com/
https://github.com/mailchimp/Email-Blueprints

https://github.com/joevandyk/premailer-rails3

#### Subdomains #########################################
http://railsapps.github.com/tutorial-rails-subdomains.html
http://bcardarella.com/post/716951242/custom-subdomains-in-rails-3
http://glacialis.postmodo.com/posts/cname-and-subdomain-routing-in-rails
#### Campain monitor #########################################
https://github.com/campaignmonitor/createsend-ruby
https://github.com/johngrimes/t-minus
https://github.com/mpowered/campaign_monitor_subscriber
http://www.campaignmonitor.com/downloads/shopify-app/
http://www.campaignmonitor.com/downloads/shopify/



#### Database Import/Export #########################################
https://github.com/jagdeep/acts_as_importable

#### Socials #########################################
http://www.postadvertising.com/
http://thuytruc.me/portfolio/saigon-posters/

#### Themes #########################################
https://github.com/lucasefe/themes_for_rails

#### Dynamic css #########################################
http://nubyonrails.com/articles/dynamic-css
https://github.com/pedro/hassle

#### Mails #########################################
http://everydayrails.com/2011/04/03/simple-rails-project-backups.html
https://github.com/sj26/mailcatcher
http://www.campaignmonitor.com/design-guidelines/


#### Caching ########################################
http://broadcastingadam.com/2011/05/advanced_caching_in_rails****
http://blog.nathanhumbert.com/2011/01/data-caching-in-rails-3.html
http://blog.endpoint.com/2011/09/ruby-on-rails-performance-overview.html
#### Admin ui ############################################
http://activeadmin.info/
https://github.com/sferik/rails_admin


PAYPAL
http://www.lafermeduweb.net/billet/tutorial-integrer-paypal-a-son-site-web-en-php-partie-1-275.html
https://cms.paypal.com/us/cgi-bin/?cmd=_render-content&content_ID=developer/library_download_sdks

#### javascript ###########################################
http://tympanus.net/codrops/2011/09/20/responsive-image-gallery/
http://tutorialzine.com/2011/06/beautiful-portfolio-html5-jquery/
http://tutorialzine.com/2011/04/jquery-webcam-photobooth/
http://tutorialzine.com/2011/03/custom-facebook-wall-jquery-graph/
http://tutorialzine.com/2011/02/converting-jquery-code-plugin/
http://tutorialzine.com/2010/11/rotating-slideshow-jquery-css3/
http://tutorialzine.com/2010/11/apple-style-splash-screen-jquery/
http://tutorialzine.com/2010/11/better-select-jquery-css3/(for select button)
http://tutorialzine.com/2010/09/google-powered-site-search-ajax-jquery/
http://tutorialzine.com/2010/07/colortips-jquery-tooltip-plugin/(Back and front)
http://tutorialzine.com/2010/06/apple-like-retina-effect-jquery-css/
http://tutorialzine.com/2010/05/showing-facebook-twitter-rss-stats-jquery-yql/
http://tutorialzine.com/2010/05/sweet-pages-a-jquery-pagination-solution/
http://tutorialzine.com/2010/04/slideout-context-tips-jquery-css3/
http://demo.tutorialzine.com/2010/02/the-jquery-hover-method/demo.html
http://tutorialzine.com/2010/02/html5-css3-website-template/(scroll)
http://tutorialzine.com/2009/12/colorful-content-accordion-css-jquery/
http://tutorialzine.com/2009/11/beautiful-apple-gallery-slideshow/
http://tutorialzine.com/2009/10/cool-login-system-php-jquery/
http://jqidealforms.com/(Compare with jquery mobile)

http://www.photoswipe.com/ !!!!!!!

http://jenwendling.com/updating-multiple-dom-elements-unobtrusively-with-ajax-in-rails/
http://jenwendling.com/quick-clean-modal-form-dialogs-w-jquery-eeeee/

http://malsup.com/jquery/block/
EXCELLENT Create a message overlay while blocking user interaction on elements or the entire page.

http://marcgrabanski.com/articles/list-of-useful-jquery-plugins
list of plugins

-- parallax
http://www.ianlunn.co.uk/demos/recreate-nikebetterworld-parallax/
https://github.com/spoof/jquery.parallax-gallery.git
#### css ###########################################
http://asidemag.com/grid/ (compare with less and suzy)
-- dropdown menu
http://sperling.com/examples/menuh/
http://csswizardry.com/demos/css-dropdown/
http://ago.tanfa.co.uk/css/examples/menu/tutorial-h.html
http://ago.tanfa.co.uk/css/examples/menu/vs7.html


################
Analytics
https://github.com/vigetlabs/garb
################
Sitemap
https://github.com/viatropos/crawlable
https://github.com/kjvarga/sitemap_generator
http://github.com/christianhellsten/sitemap-generator
https://github.com/franck/sitemap-builder/blob/master/lib/sitemap_builder/sitemap.rb
################
Image
https://github.com/smoku/plupload_rails_example
http://planetrails.com/plupload-with-rails-3
https://github.com/codeodor/plupload-rails3
https://github.com/bittersweet/plupload-example
Autre
http://www.nicosphere.net/comptabiliser-des-clicks-avec-rails-3-et-jquery-2204/
http://codequest.eu/articles/ajax-file-upload-custom-solution-or-ready-plugin

infos sur image
http://www.newmediacampaigns.com/page/how-to-optimize-an-image-for-your-website

Below are some examples of geometry strings for thumb:

'400x300'            # resize, maintain aspect ratio
'400x300!'           # force resize, don't maintain aspect ratio
'400x'               # resize width, maintain aspect ratio
'x300'               # resize height, maintain aspect ratio
'400x300>'           # resize only if the image is larger than this
'400x300<'           # resize only if the image is smaller than this
'50x50%'             # resize width and height to 50%
'400x300^'           # resize width, height to minimum 400,300, maintain aspect ratio
'2000@'              # resize so max area in pixels is 2000
'400x300#'           # resize, crop if necessary to maintain aspect ratio (centre gravity)
'400x300#ne'         # as above, north-east gravity
'400x300se'          # crop, with south-east gravity
'400x300+50+100'     # crop from the point 50,100 with width, height 400,300


#########################################################
Create zip files on the fly with ruby
http://blog.devinterface.com/2010/02/create-zip-files-on-the-fly/

def download_zip(image_list)
    if !image_list.blank?
      file_name = "pictures.zip"
      t = Tempfile.new("my-temp-filename-#{Time.now}")
      Zip::ZipOutputStream.open(t.path) do |z|
        image_list.each do |img|
          title = img.title
          title += ".jpg" unless title.end_with?(".jpg")
          z.put_next_entry(title)
          z.print IO.read(img.path)
        end
      end
      send_file t.path, :type => 'application/zip',
                             :disposition => 'attachment',
                             :filename => file_name
      t.close
    end
  end


  namespace :delayed_job do
    desc "Start delayed_job process"
    task :start, :roles => :app do
      run "cd #{current_path}; script/delayed_job start #{rails_env}"
    end

    desc "Stop delayed_job process"
    task :stop, :roles => :app do
      run "cd #{current_path}; script/delayed_job stop #{rails_env}"
    end

    desc "Restart delayed_job process"
    task :restart, :roles => :app do
      run "cd #{current_path}; script/delayed_job restart #{rails_env}"
    end
  end

  after "deploy:start", "delayed_job:start"
  after "deploy:stop", "delayed_job:stop"
  after "deploy:restart", "delayed_job:restart"

  #############################
  speed-up-assetsprecompile-with-rails
  The idea is that if you don't change your assets you don't need to recompile them each time:
  This is the solution that Ben Curtis http://www.bencurtis.com/2011/12/skipping-asset-compilation-with-capistrano/ propose for a deployment with git:
  namespace :deploy do
        namespace :assets do
          task :precompile, :roles => :web, :except => { :no_release => true } do
            from = source.next_revision(current_revision)
            if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
              run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
            else
              logger.info "Skipping asset pre-compilation because there were no asset changes"
            end
        end
      end
    end

##http://stackoverflow.com/questions/2593371/dynamic-custom-fields-for-data-model

Why not just create a model for DynamicField?

Columns:

  t.integer :dynamic_field_owner_id
  t.string :dynamic_field_owner_type
  t.string :name, :null => false
  t.string :value
  t.string :value_type_conversion, :default => 'to_s'
  # any additional fields from paperclip, has_attachment, etc.
  t.timestamps
model class:

class DynamicField > ActiveRecord::Base

  belongs_to :dynamic_field_owner, :polymorphic => true

  validates_presence_of :name
  validates_inclusion_of :value_type_conversion, :in => %w(to_s to_i to_f)
  validates :value_or_attachment

  def value
    read_attribute(:value).send(value_type_conversion)
  end

 private

 def value_or_attachment
   unless value? || file?
     errors.add_to_base('Must have either value or file')
   end
 end

end
