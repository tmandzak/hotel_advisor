class Hotel < ActiveRecord::Base
	mount_uploader :photo, AttachmentUploader
	belongs_to :user
	has_many :rates, inverse_of: :hotel
	has_one :address
	default_scope -> { order 'rate_avg DESC, rates_count DESC'}

	before_save do 
		self.title = title.strip
	end 

	validates :title, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
	validates :stars, presence: true, numericality: { only_integer: true }
end
