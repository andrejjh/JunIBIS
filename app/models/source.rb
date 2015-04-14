class Source < ActiveRecord::Base
	has_many :units, :foreign_key => "source"
	has_many :people, :foreign_key => "source"
end
