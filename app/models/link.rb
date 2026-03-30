class Link < ApplicationRecord
  has_many :views, dependent: :destroy
  belongs_to :user, optional: true
  scope :recent_first, -> { order(created_at: :desc) }
  validates :url, presence: true

  after_save_commit if: :url_previously_changed? do
    MetadataJob.perform_later(to_param)
  end

  def self.find(id)
    super Base62.decode(id)
  end

  def to_param
    Base62.encode(id)
  end

  def domain
    URI.parse(url).host
    rescue URI::InvalidURIError
  end
end
