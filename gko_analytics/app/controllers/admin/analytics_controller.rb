class Admin::AnalyticsController < Admin::BaseController
  respond_to :html
  helper_method :dimensions_list, :metrics_list
  #before_filter :profiles_list

  def report
    # @stuff = {}
    # if !params[:profile].nil?
    #   @results = Ga.query(params[:profile])
    #   @stuff = params[:profile]
    #   @start_date = Ga.start_date(params[:profile])
    #   @end_date = Ga.end_date(params[:profile])
    # end
  end

  #profile = Garb::Profile.all.detect{|p| p.table_id == params[:profile_id].to_str}
  #    report = Garb::Report.new(profile, :start_date => start_date(params), :end_date => end_date(params), :limit => params[:limit].to_str, :offset => params[:offset].to_str)
  #     report.metrics params[:metrics]
  #    report.dimensions params[:dimensions]
  #     if params[:sort] == 'desc'
  #      sort =  params[:metrics].first
  #      report.sort sort.to_sym.desc
  #    end
  #    report.results

  #def profiles_list
  #  @profiles = Ga.profiles
  #end


  def index
    get_analytics_profile # if !@profile
                          #report = Garb::Report.new(@profile)
                          #report.metrics :unique_pageviews
                          #report.dimensions :page_path
                          #report.filters :page_path.contains => params[:permalink]
                          #unique_pageviews = report.results.first.unique_pageviews
  end

  def dimensions_list
    dimensions_list = [['Visitor', ['browser', 'browserVersion', 'city', 'connectionSpeed', 'continent', 'country', 'date', 'day', 'daysSinceLastVisit', 'flashVersion', 'hostname', 'hour', 'javaEnabled', 'language', 'latitude', 'longitude', 'month', 'networkDomain', 'networkLocation', 'pageDepth', 'operatingSystem', 'operatingSystemVersion', 'region', 'screenColors', 'screenResolution', 'subContinent', 'userDefinedValue', 'visitCount', 'visitLength', 'visitorType', 'week', 'year']], ['Content', ['exitPagePath', 'landingPagePath', 'pagePath', 'pageTitle', 'secondPagePath']], ['Internal', ['searchKeyword']], ['Nav', ['nextPagePath', 'previousPagePath']], ['Campaign', ['keyword', 'medium', 'referralPath', 'source']]]
  end

  def metrics_list
    metrics_list = [['Visitor', ['bounces', 'entrances', 'exits', 'newVisits', 'pageviews', 'timeOnPage', 'timeOnSite', 'visitors', 'visits']], ['Content', ['uniquePageviews']]]
  end

  protected
  #limit of 1,000 API requests per day ??
  def get_analytics_profile
    @stuff = {}
    #session = Garb::Session.new
    #session.login("contact@hellolidays.com", "rgsbrgghmn72")
    Garb::Session.login("contact@hellolidays.com", "rgsbrgghmn72")
    @profiles = Garb::Management::Profile.all
    @profile = Garb::Management::Profile.all.detect { |p| p.web_property_id == 'UA-4428747-2' }
    #profile = Garb::Management::Profile.all.detect {|p| p.web_property_id == 'UA-4428747-2'}
    Rails.logger.info("@profile web_property_id: #{@profile.web_property_id} - table_id: #{@profile.table_id} - title: #{@profile.title} - account_id: #{@profile.account_id}")


    @total_pageviews = @profile.pageviews(:start_date => Date.today - 30, :end_date => Date.today)
    @visits = @profile.visits(:start_date => Date.today - 30, :end_date => Date.today)
    @visits_by_language = @profile.visits_by_language(:start_date => Date.today - 30, :end_date => Date.today, :filters => {:language.contains => '^fr|en|es|pt|br|ru|it'})

    Rails.logger.info("XXXXXXXXXX visits #{@visits_by_language.inspect()}}")
    @visits = @visits.try(:first)
  end


  def get_analytics_profile2
    # Multiple Sessions
    #session = Garb::Session.new
    #session.login("contact@hellolidays.com", "rgsbrgghmn72")
    Garb::Session.login("contact@hellolidays.com", "rgsbrgghmn72")
    @profile = Garb::Management::Profile.all.detect { |profile| profile.web_property_id == 'UA-4428747-2' }

    accounts = Garb::Management::Account.all(session)
    #account = accounts.first
    #Rails.logger.info("account id: #{account.id} - name: #{account.name}")
    #profile = account.profiles.first
    #Rails.logger.info("profile web_property_id: #{profile.web_property_id} - table_id: #{profile.table_id} - title: #{profile.title} - account_name: #{profile.account_name} - account_id: #{profile.account_id}")

    # or
    #Garb::Management::WebProperty
    #@profile = Garb::Management::Profile.for_web_property("UA–4428747–2", session)
    Rails.logger.info("profile web_property_id: #{@profile.web_property_id} - table_id: #{@profile.table_id} - title: #{@profile.title} - account_name: #{@profile.account_name} - account_id: #{@profile.account_id}")
  end


end

