class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :omniauthable, omniauth_providers: %i[facebook]

  has_many :attempts, dependent: :destroy
  has_many :questions , foreign_key: :user_id, dependent: :nullify
  has_many :exams , foreign_key: :user_id, dependent: :nullify

  mount_uploader :avatar, AvatarUploader

  enum role: { trainee: 0, trainer: 1, admin: 2 }

  validates :user_name, presence: true, length: {maximum: 100, minimum: 2}
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: {with: Devise.email_regexp}
  validates :password, confirmation: true, length: {within: Devise.password_length}, on: %i(create update), allow_nil: true
  validates :role, presence: true

  scope :order_created_at, -> {order(created_at: :desc)}
  scope :contributor, -> {where role: [:trainer, :admin]}
  scope :by_role, -> (role){where(role: role) if role.present?}

  def role_label
    return "primary" if admin?
    return "warning" if trainer?
    return "success" if trainee?
  end

  def manager?
    admin? || trainer?
  end

  def role_i18n
    return "Quản trị viên" if admin?
    return "Giáo viên" if trainer?
    return "Học viên" if trainee?
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.user_name = auth.info.name   # assuming the user model has a name
      user.remote_avatar_url = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
