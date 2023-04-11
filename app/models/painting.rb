class Painting < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :category
  belongs_to :type

  validates_presence_of :name, :category, :type
  validates :image, file_size: { less_than: 4.megabytes }


end
