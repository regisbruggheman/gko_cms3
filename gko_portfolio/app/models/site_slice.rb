Site.class_eval do
  has_many :portfolios
  has_many :projects, :through => :portfolios
  
  # global options for portfolio
  has_option :portfolio_sort_by, :type => :string, :default => 'position'
  has_option :portfolio_archivable, :type => :boolean, :default => false
  has_option :portfolio_archive_start_position, :type => :integer, :default => 12
  
  before_save :check_portfolio_archive_start_position
  
  def portfolio
    portfolios.live.first
  end
  
  protected
  
  def check_portfolio_archive_start_position
    self.portfolio_archive_start_position = 0 if self.portfolio_archive_start_position < 0
  end
  
end
