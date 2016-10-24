require 'net/http'

class Admin::PagesDialogsController < Admin::BaseController

  def link_to
    # TODO should be in engines documents
    @documents ||= current_site.documents.all if current_site.has_plugin?(:documents)

    @sections ||= current_site.admin_sections
    # web address link
    @web_address_text = "http://"
    @web_address_text = params[:current_link] if params[:current_link].to_s =~ /^http:\/\//
    @web_address_target_blank = (params[:target_blank] == "true")

    # mailto link
    if params[:current_link].present?
      if params[:current_link] =~ /^mailto:/
        @email_address_text = params[:current_link].split("mailto:")[1].split('?')[0]
      end
      @email_default_subject_text = params[:current_link].split('?subject=')[1] || params[:subject]
      @email_default_body_text = params[:current_link].split('?body=')[1] || params[:body]
    end
  end

end
