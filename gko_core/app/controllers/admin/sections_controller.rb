class Admin::SectionsController < Admin::ResourcesController

  belongs_to :site
  respond_to :html, :js, :xls

  before_filter :collection, :only => [:index, :new, :edit, :create]
  before_filter :protect_last_section, :only => :destroy
  before_filter :set_default_values, :only => [:new]
  custom_actions :collection => [:selected]

  cache_sweeper SectionSweeper, :only => [:create, :update, :destroy]

  def index
    if site.admin_cache_enabled && stale?( :last_modified => parent.updated_at )
      respond_to do |format|
        format.html
        format.js
        format.csv { send_data @sections.to_csv }
        format.xls { send_data @sections.to_csv(:col_sep => "\t") }
      end  
    end
  end

  def restructure
    node_id = params[:node_id].to_i
    parent_id = params[:parent_id].to_i
    prev_id = params[:prev_id].to_i
    next_id = params[:next_id].to_i

    render :text => "Do nothing" and return if parent_id.zero? && prev_id.zero? && next_id.zero?

    @section ||= current_site.sections.find(node_id)

    if prev_id.zero? && next_id.zero?
      @section.move_to_child_of current_site.sections.find(parent_id)
    elsif !prev_id.zero?
      @section.move_to_right_of current_site.sections.find(prev_id)
    elsif !next_id.zero?
      @section.move_to_left_of current_site.sections.find(next_id)
    end
  end

  def edit
    #if site.admin_cache_enabled && stale?( :etag => resource, :last_modified => resource.updated_at.utc )
      respond_with(:admin, parent, resource)
    #end
  end

  def destroy
    destroy! do |success, failure|
      success.html do
        redirect_to admin_site_sections_path(current_site, :cl => @resource_locale.to_s) and return
      end
    end
  end

  def collection
    @sections ||= site.admin_sections
  end

  
  protected

  def set_default_values
    if homepage = current_site.home
      resource.parent = homepage
    end
  end

  def protect_last_section
    if (resource.is_a?(Home) || current_site.sections.count == 1)
      resource.errors[:error] = [:last_section_cant_be_destroyed]
      redirect_to admin_site_sections_path(current_site, :cl => @resource_locale) and return
    end
  end

end
