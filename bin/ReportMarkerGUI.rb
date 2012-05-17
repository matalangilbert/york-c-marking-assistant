class ReportMarkerGUI < ReportMarker

	include GladeGUI

	def initialize
		@r1 = false
		@r2 = false
	end

	def show()
		load_glade(__FILE__)  #loads file, glade/MyClass.glade into @builder
		set_glade_all(self) #populates glade controls with insance variables (i.e. Myclass.var1)
		show_window()
	end
	
	def buttonSave__clicked(button)
		get_glade_all()
		VR::Dialog.message_box("Reqirement 1) #{@a1} 2) #{@r2}")
	end

end
