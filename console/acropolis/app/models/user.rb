class User < ActiveRecord::Base
  include Acropolis::AttachmentAccessToken
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :generate_access_token

  attr_accessor :login

  has_attached_file :avatar,
    :path => ":rails_root/public:url",
    :url => "/system/avatars/:attachment_access_token/pic_:style.:extension",
    :styles => { :medium => "300x300>", :thumb => "50x50#" },
    :default_url => "/images/:style/missing.png"

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validates :email,
    :uniqueness => {
      :case_sensitive => false
    }

  validates :name,
    :uniqueness => {
      :case_sensitive => false
    }

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
