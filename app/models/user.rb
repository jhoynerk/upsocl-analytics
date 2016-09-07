class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  has_and_belongs_to_many :campaigns

  validates :name, presence: true
  validates :password, :password_confirmation, presence: true, on: :create

  validates_presence_of :password_confirmation, if: -> { password.present? }

  def join_campaigns
    campaigns.map(&:name).join(', ')
  end
end
