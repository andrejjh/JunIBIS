class Uelink < ActiveRecord::Base
	belongs_to :unit
	belongs_to :event
	belongs_to :source, :foreign_key => "source"

end
