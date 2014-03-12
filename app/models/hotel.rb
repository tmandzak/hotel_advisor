class Hotel < ActiveRecord::Base
	belongs_to :user
	has_many :rates, inverse_of: :hotel
	has_one :address
	default_scope -> { order 'rate_avg DESC, rates_count DESC'}

    mount_uploader :photo, AttachmentUploader

	before_save do 
		self.title = title.strip
	end 

	validates :title, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
	validates :stars, presence: true, numericality: { only_integer: true }
end
