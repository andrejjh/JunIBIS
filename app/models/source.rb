class Source < ActiveRecord::Base
	belongs_to :sourcegroup
	scope :books, -> { where kind: 'book'}
	scope :games, -> { where kind: 'boardgame'}
	scope :papers, -> { where kind: 'paper'}
	scope :maps, -> { where kind: 'map'}
	scope :zines, -> { where kind: 'zine'}
	has_many :units, :foreign_key => "source"
	has_many :people, :foreign_key => "source"
	has_many :uplinks, :foreign_key => "source"
	has_many :uelinks, :foreign_key => "source"
end
