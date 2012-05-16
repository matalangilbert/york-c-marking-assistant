class ReportMarkerGUI < ReportMarker

	include GladeGUI

	def show()
		load_glade(__FILE__)  #loads file, glade/MyClass.glade into @builder
		set_glade_all(self) #populates glade controls with insance variables (i.e. Myclass.var1) 
		show_window()
	end	


end
