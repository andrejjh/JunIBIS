class Source < ActiveRecord::Base
	belongs_to :sourcegroup
	has_many :units, :foreign_key => "source"
	has_many :people, :foreign_key => "source"
	has_many :uplinks, :foreign_key => "source"
	has_many :uelinks, :foreign_key => "source"
end
