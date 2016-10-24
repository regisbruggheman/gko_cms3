class NewslettersController < ContentsController
  include Extensions::Controllers::BelongsToSection
  respond_to :html
  belongs_to :newsletter_list

  def register
    document.writeln('<img src="http://app.example.com.com/public/?q=direct_add&fn=Public_DirectAddForm&id=blkycggbjquivddbiddxylaufhfdbkj&email='+email+'&field1=firstname,set,'+firstname+'&field2=lastname,set,'+lastname+'&field3=msgpref,set,'+msgpref+'&list4=33333ec000000000000000000000003f3" width="0" height="0" border="0" alt=""/>');
  end

  protected

  def layout?
    action_name == 'show' ? 'newsletter' : super
  end
end