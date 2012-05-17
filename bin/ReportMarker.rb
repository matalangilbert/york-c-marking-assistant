class ReportMarker
  require 'prawn'

  @@marking_form_filename = "assets/assignment-mark-form.pdf"
   
  def self.input_filename
    @@marking_form_filename
  end
  
  def self.output_filename(student_number)
    "completed_marksheets/#{student_number}_c_part_one.pdf"
  end
  
  def self.generate(marker_name, student_number, marks)
    # check for required information
    if marker_name.nil? || marker_name.empty?
      raise Exception.new "marker name cannot be nil or empty"
    end
    
    if student_number.nil? || student_number.length < 2
      raise Exception.new "student number cannot be nil or less than 2 characters long"
    end
    
    # sanity check marks
    if marks[:requirements].length != 2 then input_error = "requirements" end
    if marks[:analysis].length != 7 then input_error = "analysis" end
    if marks[:specification].length != 3 then input_error = "specification" end
    if marks[:design].length != 11 then input_error = "design" end
    unless input_error.nil?
      raise Exception.new "input hash[#{input_error}] has incorrect length"
    end
    
    x = 385
    total_mark_position = {:y => 660}
    requirements_position = {:y => 582}
    analysis_position = {:y => 522}
    specification_position = {:y => 411}
    design_position = {:y => 342}
      
    Prawn::Document.generate(output_filename(student_number), :template => @@marking_form_filename, :template_page => 1) do
      
      create_stamp("marker_name") do
        draw_text marker_name, :at => [0, 0]
      end
      
      create_stamp("student_number") do
        draw_text student_number, :at => [0, 0]
      end
    
      create_stamp("date") do
        draw_text Time.new.strftime("%d/%m/%y"), :at => [0, 0]
      end
      
      create_stamp("minus") do
        draw_text "-", :at => [-5, 0]
      end
      
      # create stamps for marks 0 to 100
      0.upto(100) do |stamp_number|
        create_stamp("#{stamp_number}_mark") do
          draw_text stamp_number.to_s, :at => [0, 0]
        end
      end
      
      # Details
      stamp_at "marker_name", [85, total_mark_position[:y]]
      stamp_at "student_number", [215, total_mark_position[:y]-10]
      stamp_at "date", [77, total_mark_position[:y]-21]
      
      # Total Mark
      total_mark = marks[:requirements].inject(:+) + marks[:analysis].inject(:+) + marks[:specification].inject(:+) + marks[:design].inject(:+)
      stamp_at "#{total_mark}_mark", [x, total_mark_position[:y]]
      # Lateness
      #unless marks[:lateness].empty?
        #stamp_at "minus", [x, total_mark_position[:y]-20]
        #stamp_at "#{marks[:lateness]}_mark", [x, total_mark_position[:y]-20]
      #end
    
      #Requirements
      stamp_at "#{marks[:requirements][0]}_mark", [x, requirements_position[:y]]
      stamp_at "#{marks[:requirements][1]}_mark", [x, requirements_position[:y]-10]
      stamp_at "#{marks[:requirements].inject(:+)}_mark", [x, requirements_position[:y]-27]
      
      
      # Analysis
      stamp_at "#{marks[:analysis][0]}_mark", [x, analysis_position[:y]]
      stamp_at "#{marks[:analysis][1]}_mark", [x, analysis_position[:y]-10]
      stamp_at "#{marks[:analysis][2]}_mark", [x, analysis_position[:y]-20]
      stamp_at "#{marks[:analysis][3]}_mark", [x, analysis_position[:y]-30]
      stamp_at "#{marks[:analysis][4]}_mark", [x, analysis_position[:y]-40]
      stamp_at "#{marks[:analysis][5]}_mark", [x, analysis_position[:y]-51]
      stamp_at "#{marks[:analysis][6]}_mark", [x, analysis_position[:y]-61]
      stamp_at "#{marks[:analysis].inject(:+)}_mark", [x, analysis_position[:y]-77]
    
      # Specification
      stamp_at "#{marks[:specification][0]}_mark", [x, specification_position[:y]]
      stamp_at "#{marks[:specification][1]}_mark", [x, specification_position[:y]-10]
      stamp_at "#{marks[:specification][2]}_mark", [x, specification_position[:y]-20]
      stamp_at "#{marks[:specification].inject(:+)}_mark", [x, specification_position[:y]-37]
      
      # Design
      stamp_at "#{marks[:design][0]}_mark", [x, design_position[:y]]
      stamp_at "#{marks[:design][1]}_mark", [x, design_position[:y]-10]
      stamp_at "#{marks[:design][2]}_mark", [x, design_position[:y]-20]
      stamp_at "#{marks[:design][3]}_mark", [x, design_position[:y]-31]
      stamp_at "#{marks[:design][4]}_mark", [x, design_position[:y]-41]
      stamp_at "#{marks[:design][5]}_mark", [x, design_position[:y]-52]
      stamp_at "#{marks[:design][6]}_mark", [x, design_position[:y]-62]
      stamp_at "#{marks[:design][7]}_mark", [x, design_position[:y]-72]
      stamp_at "#{marks[:design][8]}_mark", [x, design_position[:y]-93]
      stamp_at "#{marks[:design][9]}_mark", [x, design_position[:y]-114]
      stamp_at "#{marks[:design][10]}_mark", [x, design_position[:y]-134]
      stamp_at "#{marks[:design].inject(:+)}_mark", [x, design_position[:y]-155]
    end
  end
end

