class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,
            content_type: { in: %w[image/jpeg image/png image/gif], message: "must be of valid format" },
            size: { less_than: 5.megabytes, message: "should be less than 5 megabytes" }

  def display_size
    image.variant(resize_to_limit: [500, 500])
  end
end
