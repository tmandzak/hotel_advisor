class Rate < ActiveRecord::Base
    belongs_to :user
    belongs_to :hotel, counter_cache: true, inverse_of: :rates
    default_scope -> { order 'created_at DESC, rate DESC'}

	validates :rate, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 5 }
	validates :comment, presence: true
end
