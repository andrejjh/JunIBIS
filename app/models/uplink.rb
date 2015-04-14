class Uplink < ActiveRecord::Base
	belongs_to :unit
	belongs_to :person, :class_name => "Person"
	belongs_to :role, :class_name => "Term", :foreign_key => "role_id"

end
