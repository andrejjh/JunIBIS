class Term < ActiveRecord::Base
	belongs_to :scheme

def name
	case I18n.locale
	when :de
		return name_de
	when :fr
		return name_fr
	when :nl
		return name_nl
	else
		return name_en
	end
end
end
