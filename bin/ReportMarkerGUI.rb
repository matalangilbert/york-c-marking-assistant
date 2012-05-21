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
  
  def load()
    load_glade(__FILE__) #loads file, glade/ReportMarkerGUI.glade into @builder
  end

	def show()
		set_glade_all(self) #populates glade controls with instance variables (i.e. Myclass.var1)
		show_window()
	end
  
	def buttonSave__clicked(button)
		get_glade_all() # get values of controls
    
    if ReportMarker.output_directory.nil?
      VR::Dialog.message_box("I don't know where to save the marksheets. Please tell me on the next screen.", title = "Marking Assistant")
      ReportMarker.output_directory = VR::Dialog.folder_box(@builder)
    end

    if all_details_present?
      case @builder["notepad_parts"].page
      when 0
        if File.exists?(ReportMarker.marking_form_output_filename_part_one(@student_number))
          if VR::Dialog.ok_box("You've already completed part one for this student, continuing will overwrite it.", title = "Marking Assistant")
            save_part_one
          end
        else
          save_part_one
        end
      when 1
        if File.exists?(ReportMarker.marking_form_output_filename_part_two(@student_number))
          if VR::Dialog.ok_box("You've already completed part two for this student, continuing will overwrite it.", title = "Marking Assistant")
            save_part_two
          end
        else
          save_part_two
        end
      end
      if File.exists?("data/#{@student_number}_part1.json") && File.exists?("data/#{@student_number}_part2.json")
        ReportMarker.generate_complete(@student_number)
        VR::Dialog.message_box("Completed marksheets saved to: #{ReportMarker.output_directory}", title = "Marking Assistant")
      end
    end
	end
  
  def save_part_two
    details = part_two_details
    ReportMarker.generate_part_two(details)
    details[:input_filename] = ReportMarker.summary_input_filename
    details[:output_filename] = ReportMarker.summary_output_filename_part_two(part_one_details[:student_number])
    ReportMarker.generate_summary_part_two(details)
    VR::Dialog.message_box("Part 2 saved successfully", title = "Marking Assistant")
  end
  
  def part_two_details
    details = { :marker_name => @marker_name,
        :student_number => @student_number,
        :implementation => implementation_marks,
        :code_listing => code_listing_marks,
        :testing_and_verification => testing_and_verification_marks,
        :user_manual => user_manual_marks,
        :mcpi => mcpi_marks,
        :input_filename => ReportMarker.marking_form_input_filename,
        :output_filename => ReportMarker.marking_form_output_filename_part_two(@student_number)
      }
  end
  
  def save_part_one
    details = part_one_details
    
    ReportMarker.generate_part_one(details)
    
    details[:input_filename] = ReportMarker.summary_input_filename
    details[:output_filename] = ReportMarker.summary_output_filename_part_one(part_one_details[:student_number])

    ReportMarker.generate_summary_part_one(details)
    VR::Dialog.message_box("Part 1 saved successfully", title = "Marking Assistant")
  end
  
  def part_one_details
    marks = part_one_marks
    details = {
      :marker_name => @marker_name,
      :student_number => @student_number,
      :requirements => marks[:requirements],
      :analysis => marks[:analysis],
      :specification => marks[:specification],
      :design => marks[:design],
      :input_filename => ReportMarker.marking_form_input_filename,
      :output_filename => ReportMarker.marking_form_output_filename_part_one(@student_number)
    }
  end
  
  def part_one_marks
    marks = { :requirements => requirements_marks,
      :analysis => analysis_marks,
      :specification => specification_marks,
      :design => design_marks,
    }
  end
  
  def implementation_marks
    implementation = Array.new
    1.upto(3) do |checkbox_number|
      if @builder["checkbutton_i#{checkbox_number}"].active?
        implementation << 1
      else
        implementation << 0
      end
    end
    implementation
  end
  
  def code_listing_marks
    code_listing = Array.new
    1.upto(11) do |checkbox_number|
      if @builder["checkbutton_cl#{checkbox_number}"].active?
        code_listing << 1
      else
        code_listing << 0
      end
    end
    
    1.upto(11) do |question_number|
      1.upto(11) do |additional_mark|
        unless @builder["checkbutton_cl#{question_number}_#{additional_mark}"].nil?
          if @builder["checkbutton_cl#{question_number}_#{additional_mark}"].active?
            code_listing[question_number-1] += 1
          end
        end
      end
    end
    code_listing
  end
  
  def testing_and_verification_marks
    testing_and_verification = Array.new
    1.upto(5) do |checkbox_number|
      if @builder["checkbutton_tv#{checkbox_number}"].active?
        testing_and_verification << 1
      else
        testing_and_verification << 0
      end
    end
    testing_and_verification
  end
  
  def user_manual_marks
    user_manual = Array.new
    1.upto(7) do |checkbox_number|
      if @builder["checkbutton_ui#{checkbox_number}"].active?
        user_manual << 1
      else
        user_manual << 0
      end
    end
    user_manual
  end
  
  def mcpi_marks
    mcpi = Array.new
    1.upto(5) do |checkbox_number|
      if @builder["checkbutton_mcpi#{checkbox_number}"].active?
        mcpi << 1
      else
        mcpi << 0
      end
    end
    
    1.upto(5) do |question_number|
      1.upto(5) do |additional_mark|
        unless @builder["checkbutton_mcpi#{question_number}_#{additional_mark}"].nil?
          if @builder["checkbutton_mcpi#{question_number}_#{additional_mark}"].active?
            mcpi[question_number-1] += 1
          end
        end
      end
    end
    mcpi
  end
   
  def show_validation_problems
    if @marker_name.empty?
      VR::Dialog.message_box("You forgot to fill in your name! Please put it in the box at the top.", title = "Marking Assistant")
    end
    if @student_number.length < 2
      VR::Dialog.message_box("Did you forget to fill in the student number? It should be more than 2 characters long.", title = "Marking Assistant")
    end
  end
  
  def all_details_present?
    if answer = (@marker_name.empty? || @student_number.length < 2)
      show_validation_problems
    end
    !answer
  end
  
  def requirements_marks
    requirements = Array.new
    1.upto(2) do |checkbox_number|
      if @builder["checkbutton_r#{checkbox_number}"].active?
        requirements << 1
      else
        requirements << 0
      end
    end
    requirements
  end
  
  def analysis_marks
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
    
    analysis = Array.new
    1.upto(7) do |checkbox_number|
      if @builder["checkbutton_a#{checkbox_number}"].active?
        analysis << 1
      else
        analysis << 0
      end
    end
    
    1.upto(7) do |question_number|
      1.upto(7) do |additional_mark|
        unless @builder["checkbutton_a#{question_number}_#{additional_mark}"].nil?
          if @builder["checkbutton_a#{question_number}_#{additional_mark}"].active?
            analysis[question_number-1] += 1
          end
        end
      end
    end
    analysis
  end
  
  def specification_marks
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
  
  def design_marks
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
