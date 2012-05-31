class ReportMarkerGUI < ReportMarker
	include GladeGUI
  require_relative "Generator"

  # initialize marker name and student number to allow
  # access to GUI fields as instance variables
	def initialize
    @marker_name = nil
    @student_number = "Y"
	end
  
  # load the GUI from the Glade (glade-gtk2) layout file
  def load_from_layout
    load_glade(__FILE__) #loads file, glade/ReportMarkerGUI.glade into @builder
  end

  # show the GUI window
	def show()
    load_from_layout
		set_glade_all(self) #populates glade controls with instance variables (i.e. Myclass.var1)
		show_window()
	end
  
	def buttonSave__clicked(button)
		get_glade_all() # get values of controls
    
   set_output_directory_if_required
  
#load('~/Documents/Ruby/cmarking2/bin/ReportMarker.rb')
   
    if all_details_present?
      case @builder["notepad_parts"].page
      when 0
        if File.exists?("#{ReportMarker.data_directory}/#{@student_number}_part1.json")
          if VR::Dialog.ok_box("You've already completed part one for this student, continuing will overwrite it.", title = "Marking Assistant")
            save_part_one
          end
        else
          save_part_one
        end
      when 1
        if File.exists?("#{ReportMarker.data_directory}/#{@student_number}_part2.json")
          if VR::Dialog.ok_box("You've already completed part two for this student, continuing will overwrite it.", title = "Marking Assistant")
            save_part_two
          end
        else
          save_part_two
        end
      when 2
        ReportMarker.save_demonstration_mark({
          :student_number => @student_number,
          :demonstration_mark => @builder["spinbutton_tdm"].value.to_i
        })
        VR::Dialog.message_box("Demonstration mark saved successfully",
          title = "Marking Assistant")
      end
    end
	end
  
 	def buttonGenerate__clicked(button)
    set_output_directory_if_required
    generator = Generator.new(ReportMarker.output_directory + "/data")
    generator.generate
    VR::Dialog.message_box("Generated marksheets saved to #{ReportMarker.output_directory}",
    title = "Marking Assistant")
  end
  
  def set_output_directory_if_required
    if ReportMarker.output_directory.nil?
      VR::Dialog.message_box("I don't know where to save the marksheets. "\
        "Please tell me on the next screen",
        title = "Marking Assistant")
      ReportMarker.output_directory = VR::Dialog.folder_box(@builder)
    end
  end
  
  def save_part_two
    details = part_two_details
    ReportMarker.save_part_two(details)

    VR::Dialog.message_box("Part 2 saved successfully", title = "Marking Assistant")
  end
  
  def part_two_details
    details = { :marker_name => @marker_name,
        :student_number => @student_number,
        :implementation => implementation_marks,
        :code_listing => code_listing_marks,
        :testing_and_verification => testing_and_verification_marks,
        :user_manual => user_manual_marks,
        :mcpi => mcpi_marks
      }
  end
  
  def save_part_one
    details = part_one_details
    
    ReportMarker.save_part_one(details)
    
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
    specification = Array.new
    1.upto(3) do |checkbox_number|
      if @builder["checkbutton_s#{checkbox_number}"].active?
        specification << 1
      else
        specification << 0
      end
    end
    specification
  end
  
  def design_marks
    design = Array.new
    1.upto(11) do |checkbox_number|
      if @builder["checkbutton_d#{checkbox_number}"].active?
        design << 1
      else
        design << 0
      end
    end
    
    1.upto(11) do |question_number|
      1.upto(11) do |additional_mark|
        unless @builder["checkbutton_d#{question_number}_#{additional_mark}"].nil?
          if @builder["checkbutton_d#{question_number}_#{additional_mark}"].active?
            design[question_number-1] += 1
          end
        end
      end
    end
    design
  end
  
end
