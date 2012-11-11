class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password

  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  attr_accessible :avatar
  
  has_attached_file :avatar,
    :styles => {
       :small => '50x50#',
       :medium => '250x250#',
    },
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :s3_protocol => 'https',
    :default_url => 'https://s3.amazonaws.com/vgc-assets-production/default/:style',
    :path => "/:style/:id",
    :s3_headers => { 'Expires' => 1.year.from_now.httpdate }
  
  def serializable_hash(options={})
    options.merge!(:except => [:password_digest, :remember_token])
    super(options).merge :avatar => {
      :small => avatar(:small),
      :medium => avatar(:medium),
    }
  end
  
  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
