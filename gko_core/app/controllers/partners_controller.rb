class PartnersController < BaseController
  include Extensions::Controllers::Seo
  respond_to :html
  belongs_to :partner_list

  # Save whole Page after delivery
  after_filter { |c| c.write_cache? }

  def collection
    unless get_collection_ivar
      set_collection_ivar(end_of_association_chain.with_translations(I18n.locale).order('partners.position'))
    end
    get_collection_ivar
  end

  def resource
    unless get_resource_ivar
      if params[:permalink].present?
        permalink = params[:permalink].split('/')
        c = end_of_association_chain.live.by_permalink(*permalink).first
      elsif params[:id].present?
        c = end_of_association_chain.live.find(params[:id])
      end
      set_resource_ivar(c)
    end
    get_resource_ivar
  end

  protected

  def cache_url
    @partner_list.public_url
  end

end
