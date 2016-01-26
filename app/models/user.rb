class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :update_password_salt


  private

  def update_password_salt
    return unless self.encrypted_password_changed?
    begin
      self.password_salt = SecureRandom.hex
    end while User.exists?(password_salt: password_salt)
  end

end
