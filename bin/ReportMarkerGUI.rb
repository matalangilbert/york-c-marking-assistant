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
    @marker_name = nil
    @student_number = "Y"
	end

	def show()
		load_glade(__FILE__)  #loads file, glade/ReportMarkerGUI.glade into @builder
		set_glade_all(self) #populates glade controls with insance variables (i.e. Myclass.var1)
		show_window()
	end
  
	def buttonSave__clicked(button)
		get_glade_all()
    
    unless @marker_name.empty? || @student_number.length < 2
      ReportMarker.generate(@marker_name, @student_number, marks)
    end
    if @marker_name.empty?
      VR::Dialog.message_box("You forgot to fill in your name! Please put it in the box at the top.", title = "Marking Assistant")
    end
    if @student_number.length < 2
      VR::Dialog.message_box("Did you forget to fill in the student number? It should be more than 2 characters long.", title = "Marking Assistant")
    end
	end
  
  def marks
    marks = {:requirements => requirements_totalled,
      :analysis => analysis_totalled,
      :specification => specification_totalled,
      :design => design_totalled,
    }
  end
  
  def requirements_totalled
    requirements_combined = Array.new
    requirements_checkboxes.each do |got_mark|
      if got_mark
        requirements_combined << 1
      else
        requirements_combined << 0
      end
    end
    requirements_combined
  end
  
  def analysis_totalled
    analysis_combined = Array.new
    analysis_checkboxes.each_with_index do |got_mark, index|
      case index
      when 0..4, 6, 8 # when is a question
        if got_mark
          analysis_combined << 1  # add entry to array
        else
          analysis_combined << 0
        end
      else # increment current question total
        if got_mark
          analysis_combined[analysis_combined.length-1] = analysis_combined.last + 1
        end
      end
    end
    analysis_combined
  end
  
  def specification_totalled
    specification_combined = Array.new
    specification_checkboxes.each do |got_mark|
      if got_mark
        specification_combined << 1
      else
        specification_combined << 0
      end
    end
    specification_combined
  end
  
  def design_totalled
    design_combined = Array.new
    design_checkboxes.each_with_index do |got_mark, index|
      case index
      when 0, 1, 3, 5, 7, 10, 12, 14, 17, 20, 23 # when is a question
        if got_mark
          design_combined << 1 # add entry to array
        else
          design_combined << 0
        end
      else # increment current question total
        if got_mark
          design_combined[design_combined.length-1] = design_combined.last + 1
        end
      end
    end
    design_combined
  end
  
  def requirements_checkboxes
    requirements = Array.new
    requirements << @r1 << @r2
  end
  
  def analysis_checkboxes
    analysis = Array.new
    analysis << @a1 << @a2 << @a3 << @a4 << @a5 << @a5_2 <<
      @a6 << @a6_2 << @a7 << @a7_2
  end
  
  def specification_checkboxes
    specification = Array.new
    specification << @s1 << @s2 << @s3
  end
  
  def design_checkboxes
    design = Array.new
    design << @d1 << @d2 << @d2_2 << @d3 << @d3_2 << @d4 <<
      @d4_2 << @d5 << @d5_2 << @d5_3 << @d6 << @d6_2 << @d7 <<
      @d7_2 << @d8 << @d8_2 << @d8_3 << @d9 << @d9_2 <<
      @d9_3 << @d10 << @d10_2 << @d10_3 << @d11 << @d11_2
  end

end
