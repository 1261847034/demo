class SimditorPhoto < ActiveRecord::Base

  validates :image, presence: true
  mount_uploader :image, SimditorPhotoUploader

end
