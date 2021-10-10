class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :account, dependent: :destroy
  has_one :integration, dependent: :destroy
  has_one :review_integration, dependent: :destroy
  has_one :invoice, dependent: :destroy

  after_create :create_tenant, :add_account
  after_destroy :delete_tenant

  validates :name, presence: true
  validates :subdomain, presence: true, :uniqueness => true
  validates_format_of :subdomain, with: /\A[a-z0-9_]+\Z/i, message: "- можно использовать только строчные буквы и цифры (без точек)"
  validates_length_of :subdomain, maximum: 32, message: "максимальная длина 32 знака"
  validates_exclusion_of :subdomain, in: ['www', 'mail', 'ftp', 'admin', 'test', 'public', 'private', 'staging', 'app', 'web', 'net'], message: "эти слова использовать нельзя"

  def create_tenant
    Apartment::Tenant.create(subdomain)
  end

  def add_account
    create_account
  end

  def delete_tenant
    Apartment::Tenant.drop(subdomain)
  end

  def admin?
    role == 'Admin'
  end
end
