class TestimonialsController < ContentsController
  respond_to :html
  belongs_to :testimonial_list

  
  protected
  
  def load_resources
    end_of_association_chain.with_globalize
  end

  def find_resource
    if params[:permalink].present?
      permalink = params[:permalink].split('/')
      begin
        c = end_of_association_chain.by_permalink(*permalink).first
      rescue
        error_404
      end
    elsif params[:id].present?
      begin
        c = end_of_association_chain.find(params[:id])
      rescue
        error_404
      end
    end
    set_resource_ivar(c)
  end 
end