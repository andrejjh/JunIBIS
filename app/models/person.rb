class Person < ActiveRecord::Base
	belongs_to :rank, :class_name => "Term", :foreign_key => "rank"
	belongs_to :title, :class_name => "Term", :foreign_key => "title"
	belongs_to :nation, :class_name => "Term", :foreign_key => "nation"
	belongs_to :source, :foreign_key => "source"

	has_many :uplinks
	has_many :units, :through => :uplinks
	def fullname
		fullname= ''
		fullname+= rank.name + ' ' unless rank.nil?
		fullname+= title.name + ' ' unless title.nil?
		fullname+= firstname + ' ' + lastname
	end
end
