class Legenditem < ActiveRecord::Base
	belongs_to :legendGroup
	def name
		case I18n.locale
		when :de
			n= name_de.nil? ?  name_en + "_de" : name_de
		when :fr
			n= name_fr.nil? ? name_en + "_fr" : name_fr
		when :nl
			n= name_nl.nil? ? name_en + "_nl" : name_nl
		else
			n= name_en
		end
		return n
	end

end
