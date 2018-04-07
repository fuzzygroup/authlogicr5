#encoding: utf-8
class User < ApplicationRecord
  
  #https://www.sitepoint.com/rails-authentication-with-authlogic/ <== source for all the authlogic stuff
  
  #########################################################################
  #
  # class level directives
  #
  #########################################################################
  #paginates_per 20
  
  #if Rails.root.to_s =~ /_site/ || Rails.root.to_s =~ /_web/ || Rails.root.to_s =~ /_admin/ || Rails.env.production?
    acts_as_authentic do |c|
      c.crypto_provider = Authlogic::CryptoProviders::Sha512
      #c.consecutive_failed_logins_limit = 10
      c.login_field = :email
    end
    #end
  
  serialize :details
  #########################################################################
  #
  # attr_accessible
  #
  #########################################################################
  #attr_accessor :date_created
  attr_accessor :coupon_code
  attr_accessor :creation_context
  attr_accessor :tos

  #########################################################################
  #
  # validations
  #
  #########################################################################

  #validates_presence_of :username
  validates_presence_of :email
  
  #validates_uniqueness_of :username
  validates_uniqueness_of :email
  
  validate :ensure_tos
  
  #validate :username_is_valid_dns
  
  # model level validation doesn't work; bizarre; rails 5 maybe?
  def ensure_tos
    return true
    errors.add(:tos, "Must be accepted to create an account") if !self[:tos]
  end

  #########################################################################
  #
  # belongs_to
  #
  #########################################################################

  #########################################################################
  #
  # has_many
  #
  #########################################################################
  has_many :logins
  has_many :job_search_urls
  has_many :jobs
  has_many :notes
  has_many :cover_letters
  has_many :tasks
  has_many :news_feed_items
  has_many :deadlines
  has_many :possible_times
  #has_many :alert_addresses

  def subscribed?
    stripe_subscription_id?
  end


  #########################################################################
  #
  # call backs
  #
  #########################################################################


  #########################################################################
  #
  # scopes
  #
  #########################################################################
  scope :active, -> { (where :active => true).order("id ASC")}


  #########################################################################
  #
  # CLASS METHODS
  #
  #########################################################################
  def self.truncate(foo = nil)
    return if Rails.env.production?
    ActiveRecord::Base.connection.execute("TRUNCATE #{self.table_name}")
  end
  
  def self.find_or_create(email, password, params = nil)
    u = User.where(:email => email).first
    return u if u
    
    u = User.new
    #u.username = username
    u.email = email
    u.password = password
    u.password_confirmation = password
    if params
      u.time_zone = params[:time_zone] 
      u.active = params[:active] 
      u.confirmed = params[:confirmed] 
      u.approved = params[:approved] 
      u.last_name = params[:last_name]
      #u.details = {:amazon_referrer_code => params[:amazon_referrer_code]}
    end
    
    if u.save
      #db_name = Db.create_hyde_web_database_for_user(u)
      return u
    else
      puts "email = #{email}"
      raise u.errors.full_messages.inspect
    end
  end



  #########################################################################
  #
  # INSTANCE METHODS
  #
  #########################################################################
  def needs_setup_wizard?
    return true if (self.job_search_urls.count == 0) #&& self.alert_addresses.count == 0 && self.budgets.count == 0)
    return false
  end
  
  def receives_email_alerts?
    return true
  end
  
  def receives_text_message_alerts?
    return true if self.subscription_type == "pro"
    return true if self.subscription_type == "silver"
    return true if self.subscription_type == "big_family"
    return true if self.subscription_type == "gold"
    return false
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    PasswordResetMailer.reset_email(self).deliver_now
  end
  
  def is_admin?
    return true if self.admin
    return false
  end
  
  def value
    "N.A."
  end
  
  def full_name
    "#{self.first_name} #{self.last_name}" 
  end
  
  
  
  def hyde_database_name
    "hyde_web_#{self.id}_#{Rails.env}"
  end

  def database_name
    "seira_watch_site_#{Rails.env}"
  end
  
  def user_database_name
    "#{DATABASE_PREFIX}_#{self.id}_#{Rails.env}"
  end
  
  def migrate_database
    require 'tempfile'
    file = Tempfile.new('migrator')
    parts = file.path.split("/")
    file_name = "/Users/sjohnson/Dropbox/fuzzygroup/hyde/seira_watch_web_app/#{parts.last}"
    File.open(file_name, "w") do |f|
      f.write "#!/bin/bash\n"
      f.write "export SEIRA_USER_ID=#{self.id}\n"
      f.write "bundle exec rake db:migrate\n"
    end
    `chmod +x #{file_name}`
    `#{file_name}`
  end
  
  # params = {:username => "demo", :email => "demo@seirawatch.com", :password => "test", :first_name => "Mark", :password => "test", :last_name => "Pierce"}
  def self.create_database_and_add_root_user(params = nil)
    # Send an API call over to the app to create the db
    db_create_results = WebAppApi.create_tenant_db(params[:username])
    
    # send an API call over to the app to send the user over to the db
    user_create_results = WebAppApi.create_tenant_user(params[:username], params[:email], params[:password], params[:first_name], params[:last_name])
  end
  
  def create_database_and_add_root_user_without_apartment(params = nil)
    #
    # database to create
    #
    database_name = self.user_database_name
    
    #
    # create a seira_watch_web database
    #
    database = DbCommon.create_database_for_user(self) unless DbCommon.database_exists?(database_name)
    
    #
    # run migrations to insert the table structure
    #
    self.migrate_database unless DbCommon.database_has_tables?(database_name)
    
    #`export SEIRA_USER_ID=#{self.id}; /Users/sjohnson/Dropbox/fuzzygroup/hyde/seira_watch_web_app/migrate_table.sh`
    #debugger
    
    dump_cmd = "mysqldump -uroot seira_watch_site_#{Rails.env} users --where='id=#{self.id}' > #{Rails.root}/tmp.sql"
    
    # This really has to function via an API on a newly created instance 
    # that we either launch via docker or aws or ansible  via an AMI
    row = {}
    row[:username] = self.username
    row[:email] = self.email
    row[:first_name] = self.first_name
    row[:password] = self.pwpt
    row[:password_confirmation] = self.pwpt
    row[:pwpt] = self.pwpt
    
    # needs to post to an API which gets the values into a db -- maybe by creating it here and dumping the raw sql into another database
    
    # DbCommon.insert_row_into_table(database_name, "users", row)
    #
    #
    # row = {}
    # row[:username] = "nickjj"
    # row[:email] = "nickjanetakis@gmail.com"
    # row[:first_name] = "Nick"
    # row[:password] = "test1234"
    # row[:password_confirmation] = "test1234"
    # row[:pwpt] = "test1234"
    # User.find_or_create(row[:username], row[:email], row[:pwpt], row)
    
    return database# api call to send the user over to the web
  end
  
  def import_from_hyde
    
  end

  
  def last_login
    self.logins.last
  end
  
  # def login_count
  #   self.logins.size
  # end
  
  def user_name
    return self.username
  end
  
  def account_type
    return self.details[:hyde_account_type] ||= "base"
  end
  
  def version_url_check_timestamp
    # get the version from the account
  
    return Time.now
  end
  


  #########################################################################
  #
  # PRIVATE METHODS
  #
  #########################################################################
  
  private
  
  #########################################################################
  #
  # PROTECTED METHODS
  #
  #########################################################################
    
  protected
  
  
end
