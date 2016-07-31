class Owner < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true, length: { minimum: 5, maximum: 100 }
  validates :address1, presence: true, length: { maximum: 300 }
  validates :address2, length: { maximum: 300 }
  validates :address3, length: { maximum: 300 }
  validates :country, presence: true, length: { minimum: 2 }
  validates :county, presence: true
  validates :city, presence: true
  validates :town, presence: true
  validates :postcode, presence: true
  validates :telephone, presence: true

  has_many :sites
end
