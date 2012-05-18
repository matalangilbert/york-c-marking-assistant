class ReportMarker
  require 'prawn'

  def self.marking_form_input_filename
    "assets/assignment-mark-form.pdf"
  end
  
  def self.summary_input_filename
    "assets/summary-mark-form.pdf"
  end
  
  def self.marking_form_output_filename(student_number)
    "completed_marksheets/#{student_number}_assignment-mark-form.pdf"
  end

  def self.summary_output_filename(student_number)
    "completed_marksheets/#{student_number}_summary.pdf"
  end
 
  def self.generate_part_one(marker_name, student_number, marks)
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
      
    Prawn::Document.generate(marking_form_output_filename(student_number), :template => marking_form_input_filename, :template_page => 1) do
      
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

    part_one_details = {:marker_name => marker_name,
      :student_number => student_number,
      :requirements => marks[:requirements].inject(:+),
      :analysis => marks[:analysis].inject(:+),
      :specification => marks[:specification].inject(:+)
    }
    generate_summary_part_one(part_one_details)
  
  end
  
  def self.test_generate_summary_part_one(details)
    details = { :marker_name => "Mat",
      :student_number => "Y99",
      :requirements => 3,
      :analysis => 5,
      :specification => 10,
      :design => 10,
      :input_filename => marking_form_input_filename
    }
  end

  def self.test_generate_part_two_details
    details = { :implementation => [1,1,1],
      :code_listing => [1,1,1,1,1,1,1,1,1,1,0],
      :testing_and_verification => [1,1,1,1,1],
      :user_manual => [1,1,1,1,1,1,1],
      :mcpi => [1,1,1,1,1],
      :input_filename => marking_form_input_filename,
      :output_filename => "completed_marksheets/test.pdf"
    }
  end

  def self.generate_part_two(details)
    x = 385
    
    Prawn::Document.generate(details[:output_filename],
      :template => details[:input_filename]) do
      
      go_to_page(2)
        
      0.upto(100) do |stamp_number|
        create_stamp("#{stamp_number}_mark") do
          draw_text stamp_number.to_s, :at => [0, 0]
        end
      end
      
      create_stamp("minus") do
        draw_text "-", :at => [-5, 0]
      end
      
      # Implementation Report
      stamp_at("#{details[:implementation][0]}_mark", [x, 648])
      stamp_at("#{details[:implementation][1]}_mark", [x, 638])
      stamp_at("#{details[:implementation][2]}_mark", [x, 627])
      stamp_at("#{details[:implementation].inject(:+)}_mark", [x, 611])

      # Code Listing
      code_listing_y = 578
      stamp_at("#{details[:code_listing][0]}_mark", [x, code_listing_y])
      stamp_at("#{details[:code_listing][1]}_mark", [x, code_listing_y-10])
      stamp_at("#{details[:code_listing][2]}_mark", [x, code_listing_y-20])
      stamp_at("#{details[:code_listing][3]}_mark", [x, code_listing_y-31])
      stamp_at("#{details[:code_listing][4]}_mark", [x, code_listing_y-41])
      stamp_at("#{details[:code_listing][5]}_mark", [x, code_listing_y-51])
      stamp_at("#{details[:code_listing][6]}_mark", [x, code_listing_y-62])
      stamp_at("#{details[:code_listing][7]}_mark", [x, code_listing_y-72])
      stamp_at("#{details[:code_listing][8]}_mark", [x, code_listing_y-82])

      stamp_at("minus", [x, code_listing_y-98]) unless details[:code_listing][9] == 0
      stamp_at("#{details[:code_listing][9]}_mark", [x, code_listing_y-98])
      
      stamp_at("minus", [x, code_listing_y-109]) unless details[:code_listing][10] == 0
      stamp_at("#{details[:code_listing][10]}_mark", [x, code_listing_y-109])
      
      
      code_listing_total_marks = 0
      0.upto(8) do |i|
        code_listing_total_marks += details[:code_listing][i]
      end
      9.upto(10) do |i|
        code_listing_total_marks -= details[:code_listing][i]
      end
      
      stamp_at("#{code_listing_total_marks}_mark", [x, code_listing_y-125])
      
      # Testing and Verification
      testing_verification_y = 420
      stamp_at("#{details[:testing_and_verification][0]}_mark", [x, testing_verification_y])
      stamp_at("#{details[:testing_and_verification][1]}_mark", [x, testing_verification_y-10])
      stamp_at("#{details[:testing_and_verification][2]}_mark", [x, testing_verification_y-21])
      stamp_at("#{details[:testing_and_verification][3]}_mark", [x, testing_verification_y-31])
      stamp_at("#{details[:testing_and_verification][4]}_mark", [x, testing_verification_y-42])
      stamp_at("#{details[:testing_and_verification].inject(:+)}_mark", [x, testing_verification_y-58])
      
      # User Manual
      user_manual_y = 330
      stamp_at("#{details[:user_manual][0]}_mark", [x, user_manual_y])
      stamp_at("#{details[:user_manual][1]}_mark", [x, user_manual_y-10])
      stamp_at("#{details[:user_manual][2]}_mark", [x, user_manual_y-21])
      stamp_at("#{details[:user_manual][3]}_mark", [x, user_manual_y-31])
      stamp_at("#{details[:user_manual][4]}_mark", [x, user_manual_y-41])
      stamp_at("#{details[:user_manual][5]}_mark", [x, user_manual_y-52])
      stamp_at("#{details[:user_manual][6]}_mark", [x, user_manual_y-62])
      stamp_at("#{details[:user_manual].inject(:+)}_mark", [x, user_manual_y-79])
      
      # Maturity, Consistency, Presentation and Innovation
      mcpi_y = 219
      stamp_at("#{details[:mcpi][0]}_mark", [x, mcpi_y])
      stamp_at("#{details[:mcpi][1]}_mark", [x, mcpi_y-11])
      stamp_at("#{details[:mcpi][2]}_mark", [x, mcpi_y-21])
      stamp_at("#{details[:mcpi][3]}_mark", [x, mcpi_y-31])
      
      stamp_at("minus", [x, mcpi_y-61]) unless details[:mcpi][4] == 0
      stamp_at("#{details[:mcpi][4]}_mark", [x, mcpi_y-61])
      
      mcpi_total_marks = 0
      0.upto(3) do |i|
        mcpi_total_marks += details[:mcpi][i]
      end
      mcpi_total_marks -= details[:mcpi][4]
      stamp_at("#{mcpi_total_marks}_mark", [x, mcpi_y-81])
        
    end # Prawn::Document.generate
  end
  
  def self.generate_summary_part_one(details)
    Prawn::Document.generate(summary_output_filename(details[:student_number]), :template => summary_input_filename) do
      create_stamp("marker_name") do
        draw_text details[:marker_name], :at => [0, 0]
      end
      
      create_stamp("student_number") do
        draw_text details[:student_number], :at => [0, 0]
      end
    
      0.upto(100) do |stamp_number|
      create_stamp("#{stamp_number}_mark") do
        draw_text stamp_number.to_s, :at => [0, 0]
        end
      end
      
      stamp_at("student_number", [235,652])
      stamp_at("marker_name", [90,627])
      
      totals_x_position = 380
      # Requirements, Analysis and Specification
      ras = details[:requirements] +
      details[:analysis] +
      details[:specification]
      stamp_at("#{ras}_mark", [totals_x_position,557])
      
      # Design
      stamp_at("#{details[:design]}_mark",
        [totals_x_position, 540])
    end
  end

end

