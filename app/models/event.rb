class Event < ActiveRecord::Base
	belongs_to :kind, :class_name => "Term", :foreign_key => "kind"

	has_many :uelinks
	has_many :units, :through => :uelinks
end
