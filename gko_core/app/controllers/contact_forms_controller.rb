# app/controllers/contact_forms.rb
class ContactFormsController < BaseController
  def new
    @contact_form = ContactForm.new
    respond_with(@contact_form, :template => 'pages/contact')
  end

  def create
    begin
      @page = site.sections.find_by_template('contact')
      @contact_form = ContactForm.new(params[:contact_form])
      @contact_form.request = request
      if @contact_form.deliver
        flash.now[:notice] = 'Thank you for your message!'
        respond_with(@contact_form, :template => 'pages/contact')
      else
        respond_with(@contact_form, :template => 'pages/contact')
      end
    rescue ScriptError
      flash[:error] = 'Sorry, this message appears to be spam and was not delivered.'
    end
  end

end