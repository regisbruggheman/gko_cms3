module BootstrapHelper 
  
  # Recursively render arranged nodes hash
  #
  # == Params
  #  * +hash+ - Hash or arranged nodes, i.e. Category.arrange
  #  * +options+ - HTML options for root ul node.
  #    Given options with ex. :sort => lambda{|x| x.name}
  #    you allow node sorting by analogy with sorted_nested_set_options helper method
  #  * +&block+ - A block that will be used to display node
  #
  # == Usage
  #
  #   arranged_nodes = Category.arrange
  #
  #   <%= render_tree arranged_nodes do |node, child| %>
  #     <li><%= node.name %></li>
  #     <%= child %>
  #   <% end %>
  #
  def bootstrap_render_tree hash, options = {}, &block
    sort_proc = options.delete :sort
    tag = options.delete(:tag) || :ul

    content_tag tag, options do
      hash.keys.sort_by(&sort_proc).each do |node|
        block.call node, render_tree(hash[node], :sort => sort_proc, :class => 'nav nav-list children', &block)
      end
    end if hash.present?
  end 

  def container_tag(clazz, &block)
    content_tag(:div, :class => "outercontainer outercontainer-#{clazz}") do
      content_tag(:div, :class => "container-fluid") do
        content_tag(:div, :class => "row-fluid") do
          capture(&block)
        end
      end
    end
  end

end