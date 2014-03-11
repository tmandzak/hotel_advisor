class Rate < ActiveRecord::Base
    belongs_to :user
    belongs_to :hotel, counter_cache: true, inverse_of: :rates
    default_scope -> { order 'created_at DESC, rate DESC'}

	validates :rate, presence: true
	validates :comment, presence: true
end
