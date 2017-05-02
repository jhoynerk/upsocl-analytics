class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  role_based_authorizable

  has_and_belongs_to_many :campaigns

  validates :name, presence: true
  validates :password, :password_confirmation, presence: true, on: :create
  validates :email, uniqueness: true

  validates_presence_of :password_confirmation, if: -> { password.present? }
  validates_confirmation_of :password

  def can_view_admin?
    ['country_manager', 'admin'].include?(role)
  end

  def join_campaigns
    campaigns.map(&:name).join(', ')
  end
end
