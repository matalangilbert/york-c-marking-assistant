class ReportMarkerGUI < ReportMarker

	include GladeGUI

	def initialize
		@r1 = @r2 = false
    @a1 = @a2 = @a3 = @a4 = @a5 =@a5_2 = @a6 = @a6_2 = false
    @a7 = @a7_2 = false
    @s1 = @s2 = @s3 = false
    @d1 = @d2 = @d2_2 = @d3 = @d3_2 = @d4 = @d4_2 = @d5 = false
    @d5_2 = @d5_3 = @d6 = @d6_2 = @d7 = @d7_2 = false
    @d8 = @d8_2 = @d8_3 = @d9 = @d9_2 = @d9_3 = @d10 = false
    @d10_2 = @d10_3 = @d11 = @d11_2 = false
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
