class Unit < ActiveRecord::Base

	belongs_to :nation, :class_name => "Term", :foreign_key => "nation"
	belongs_to :category, :class_name => "Term", :foreign_key => "category"
	belongs_to :absence, :class_name => "Term", :foreign_key => "absence"
	belongs_to :source, :foreign_key => "source"

	has_many :children, :class_name => "Unit", :foreign_key => "parent_id"
	belongs_to :parent, :class_name => "Unit"
  belongs_to :icon, :class_name => "Icon", :foreign_key => "icon"

	has_many :uplinks
	has_many :people, :through => :uplinks

	has_many :uelinks
	has_many :events, :through => :uelinks

	scope :armies, -> {where('parent_id IS null')}
end
