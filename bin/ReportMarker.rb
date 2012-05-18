class ReportMarker
  require 'prawn'
  require 'json'

  def self.marking_form_input_filename
    "assets/assignment-mark-form.pdf"
  end
  
  def self.summary_input_filename
    "assets/summary-mark-form.pdf"
  end
  
  def self.output_directory
    "completed_marksheets"
  end
   
  def self.marking_form_output_filename_part_one(student_number)
    "#{output_directory}/part_1/#{student_number}_assignment-mark-form_part_1.pdf"
  end

  def self.summary_output_filename_part_one(student_number)
    "#{output_directory}/part_1/#{student_number}_summary_part_1.pdf"
  end
  
  def self.marking_form_output_filename_part_two(student_number)
    "#{output_directory}/part_2/#{student_number}_assignment-mark-form_part_2.pdf"
  end

  def self.summary_output_filename_part_two(student_number)
    "#{output_directory}/part_2/#{student_number}_summary_part_2.pdf"
  end
  
  def self.marking_form_output_filename(student_number)
    "#{output_directory}/#{student_number}_assignment-mark-form.pdf"
  end
  
  def self.summary_out_output_filename(student_number)
    "#{output_directory}/#{student_number}_summary.pdf"
  end
 
  def self.check_details(details)
    # check for required information
    if details[:marker_name].nil? || details[:marker_name].empty?
      raise Exception.new "marker name cannot be nil or empty"
    end
    
    if details[:student_number].nil? || details[:student_number].length < 2
      raise Exception.new "student number cannot be nil or less than 2 characters long"
    end
  end
    
  def self.generate_complete(student_number)
    part_one_details = nil
    File.open("data/#{student_number}_part1.json","r") do |f|
      part_one_details = JSON.parse(f.read, :symbolize_names => true)
    end
    
    part_two_details = nil
    File.open("data/#{student_number}_part2.json","r") do |f|
      part_two_details = JSON.parse(f.read, :symbolize_names => true)
    end
    
    details = part_one_details.merge(part_two_details)
    details[:input_filename] = "#{marking_form_input_filename}"
    details[:output_filename] = "#{marking_form_output_filename(student_number)}"
    
    save(details)
    
  end
  
  def self.save(details)
    x = 385
    total_mark_position = {:y => 660}
    requirements_position = {:y => 582}
    analysis_position = {:y => 522}
    specification_position = {:y => 411}
    design_position = {:y => 342}
      
    Prawn::Document.generate(details[:output_filename],
    :template => details[:input_filename]) do
      
      create_stamp("marker_name") do
        draw_text details[:marker_name], :at => [0, 0]
      end
      
      create_stamp("student_number") do
        draw_text details[:student_number], :at => [0, 0]
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
        
      # Lateness
      #unless details[:lateness].empty?
        #stamp_at "minus", [x, total_mark_position[:y]-20]
        #stamp_at "#{details[:lateness]}_mark", [x, total_mark_position[:y]-20]
      #end
    
      #Requirements
      stamp_at "#{details[:requirements][0]}_mark", [x, requirements_position[:y]]
      stamp_at "#{details[:requirements][1]}_mark", [x, requirements_position[:y]-10]
      stamp_at "#{details[:requirements].inject(:+)}_mark", [x, requirements_position[:y]-27]
      
      
      # Analysis
      stamp_at "#{details[:analysis][0]}_mark", [x, analysis_position[:y]]
      stamp_at "#{details[:analysis][1]}_mark", [x, analysis_position[:y]-10]
      stamp_at "#{details[:analysis][2]}_mark", [x, analysis_position[:y]-20]
      stamp_at "#{details[:analysis][3]}_mark", [x, analysis_position[:y]-30]
      stamp_at "#{details[:analysis][4]}_mark", [x, analysis_position[:y]-40]
      stamp_at "#{details[:analysis][5]}_mark", [x, analysis_position[:y]-51]
      stamp_at "#{details[:analysis][6]}_mark", [x, analysis_position[:y]-61]
      stamp_at "#{details[:analysis].inject(:+)}_mark", [x, analysis_position[:y]-77]
    
      # Specification
      stamp_at "#{details[:specification][0]}_mark", [x, specification_position[:y]]
      stamp_at "#{details[:specification][1]}_mark", [x, specification_position[:y]-10]
      stamp_at "#{details[:specification][2]}_mark", [x, specification_position[:y]-20]
      stamp_at "#{details[:specification].inject(:+)}_mark", [x, specification_position[:y]-37]
      
      # Design
      stamp_at "#{details[:design][0]}_mark", [x, design_position[:y]]
      stamp_at "#{details[:design][1]}_mark", [x, design_position[:y]-10]
      stamp_at "#{details[:design][2]}_mark", [x, design_position[:y]-20]
      stamp_at "#{details[:design][3]}_mark", [x, design_position[:y]-31]
      stamp_at "#{details[:design][4]}_mark", [x, design_position[:y]-41]
      stamp_at "#{details[:design][5]}_mark", [x, design_position[:y]-52]
      stamp_at "#{details[:design][6]}_mark", [x, design_position[:y]-62]
      stamp_at "#{details[:design][7]}_mark", [x, design_position[:y]-72]
      stamp_at "#{details[:design][8]}_mark", [x, design_position[:y]-93]
      stamp_at "#{details[:design][9]}_mark", [x, design_position[:y]-114]
      stamp_at "#{details[:design][10]}_mark", [x, design_position[:y]-134]
      stamp_at "#{details[:design].inject(:+)}_mark", [x, design_position[:y]-155]
      
      go_to_page(2)

      x = 385
      y = 660
      
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
      
      if code_listing_total_marks < 0
        stamp_at("#{code_listing_total_marks*-1}_mark", [x, code_listing_y-125])
        stamp_at("minus", [x, code_listing_y-125] )
      else
        stamp_at("#{code_listing_total_marks}_mark", [x, code_listing_y-125])
      end
      
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
      if mcpi_total_marks < 0
        stamp_at("#{mcpi_total_marks*-1}_mark", [x, mcpi_y-81])
        stamp_at("minus", [x, mcpi_y-81])
      else
        stamp_at("#{mcpi_total_marks}_mark", [x, mcpi_y-81])
      end
      
     # Total Mark
      total_mark = details[:requirements].inject(:+) +
        details[:analysis].inject(:+) +
        details[:specification].inject(:+) +
        details[:design].inject(:+) +
        details[:implementation].inject(:+) +
        code_listing_total_marks +
        details[:testing_and_verification].inject(:+) +
        details[:user_manual].inject(:+) +
        mcpi_total_marks
      go_to_page(1)
      stamp_at "#{total_mark}_mark", [x, total_mark_position[:y]]
    end
    generate_summary(details)
    
  end
    
  def self.generate_summary(details)
    
    # remove negative marks
    code_listing = 0
    0.upto(8) do |question|
      code_listing += details[:code_listing][question]
    end
    9.upto(10) do |penalty|
      code_listing -= details[:code_listing][penalty]
    end
    
    mcpi = 0
    0.upto(3) do |question|
      mcpi += details[:mcpi][question]
    end
    mcpi -= details[:mcpi][4]
    
    summary_details = { :marker_name => details[:marker_name],
    :student_number => details[:student_number],
    :requirements => details[:requirements].inject(:+),
    :analysis => details[:analysis].inject(:+),
    :specification => details[:specification].inject(:+),
    :design => details[:design].inject(:+),
    :implementation => details[:implementation].inject(:+),
    :code_listing => code_listing,
    :testing_and_verification => details[:testing_and_verification].inject(:+),
    :user_manual => details[:user_manual].inject(:+),
    :mcpi => mcpi,
    :input_filename => summary_input_filename,
    :output_filename => "#{summary_out_output_filename(details[:student_number])}"
    }
    

    Prawn::Document.generate(summary_details[:output_filename], :template => summary_details[:input_filename]) do
      create_stamp("marker_name") do
        draw_text summary_details[:marker_name], :at => [0, 0]
      end
      
      create_stamp("student_number") do
        draw_text summary_details[:student_number], :at => [0, 0]
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
      ras = summary_details[:requirements] +
        summary_details[:analysis] +
        summary_details[:specification]
      stamp_at("#{ras}_mark", [totals_x_position,557])
      
      p summary_details[:design]
      # Design
      stamp_at("#{summary_details[:design]}_mark",
        [totals_x_position, 540])
        
      # Implementation Report and Code Listing
      icl = summary_details[:implementation] +
        summary_details[:code_listing]
      
      if icl < 0
        stamp_at("#{icl*-1}_mark", [totals_x_position,520])
        stamp_at("minus", [totals_x_position,520])
      else
        stamp_at("#{icl}_mark", [totals_x_position,520])
      end
      
      # Testing and Verification and User Manual
      tv_ui = summary_details[:testing_and_verification] +
        summary_details[:user_manual]
      stamp_at("#{tv_ui}_mark", [totals_x_position,503])
      
      # Maturity, Consistency, Presentation and Innovation
      if summary_details[:mcpi] < 0
        stamp_at("minus", [totals_x_position,484])
        stamp_at("#{summary_details[:mcpi]*-1}_mark",
          [totals_x_position,484])
      else
        stamp_at("#{summary_details[:mcpi]}_mark",
          [totals_x_position,484])
      end
    end
  end
  
  def self.generate_part_one(details)
    
    check_details(details)
    
    # sanity check marks
    if details[:requirements].length != 2 then input_error = "requirements" end
    if details[:analysis].length != 7 then input_error = "analysis" end
    if details[:specification].length != 3 then input_error = "specification" end
    if details[:design].length != 11 then input_error = "design" end
    unless input_error.nil?
      raise Exception.new "input hash[#{input_error}] has incorrect length"
    end
    
    # write to json file for later retrieval
    File.open("data/#{details[:student_number]}_part1.json","w") do |f|
      f.write(details.to_json)
    end
    
    x = 385
    total_mark_position = {:y => 660}
    requirements_position = {:y => 582}
    analysis_position = {:y => 522}
    specification_position = {:y => 411}
    design_position = {:y => 342}
      
    Prawn::Document.generate(details[:output_filename],
      :template => details[:input_filename]) do
      
      create_stamp("marker_name") do
        draw_text details[:marker_name], :at => [0, 0]
      end
      
      create_stamp("student_number") do
        draw_text details[:student_number], :at => [0, 0]
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
      #total_mark = details[:requirements].inject(:+) + details[:analysis].inject(:+) + details[:specification].inject(:+) + details[:design].inject(:+)
      #stamp_at "#{total_mark}_mark", [x, total_mark_position[:y]]
      # Lateness
      #unless details[:lateness].empty?
        #stamp_at "minus", [x, total_mark_position[:y]-20]
        #stamp_at "#{details[:lateness]}_mark", [x, total_mark_position[:y]-20]
      #end
    
      #Requirements
      stamp_at "#{details[:requirements][0]}_mark", [x, requirements_position[:y]]
      stamp_at "#{details[:requirements][1]}_mark", [x, requirements_position[:y]-10]
      stamp_at "#{details[:requirements].inject(:+)}_mark", [x, requirements_position[:y]-27]
      
      
      # Analysis
      stamp_at "#{details[:analysis][0]}_mark", [x, analysis_position[:y]]
      stamp_at "#{details[:analysis][1]}_mark", [x, analysis_position[:y]-10]
      stamp_at "#{details[:analysis][2]}_mark", [x, analysis_position[:y]-20]
      stamp_at "#{details[:analysis][3]}_mark", [x, analysis_position[:y]-30]
      stamp_at "#{details[:analysis][4]}_mark", [x, analysis_position[:y]-40]
      stamp_at "#{details[:analysis][5]}_mark", [x, analysis_position[:y]-51]
      stamp_at "#{details[:analysis][6]}_mark", [x, analysis_position[:y]-61]
      stamp_at "#{details[:analysis].inject(:+)}_mark", [x, analysis_position[:y]-77]
    
      # Specification
      stamp_at "#{details[:specification][0]}_mark", [x, specification_position[:y]]
      stamp_at "#{details[:specification][1]}_mark", [x, specification_position[:y]-10]
      stamp_at "#{details[:specification][2]}_mark", [x, specification_position[:y]-20]
      stamp_at "#{details[:specification].inject(:+)}_mark", [x, specification_position[:y]-37]
      
      # Design
      stamp_at "#{details[:design][0]}_mark", [x, design_position[:y]]
      stamp_at "#{details[:design][1]}_mark", [x, design_position[:y]-10]
      stamp_at "#{details[:design][2]}_mark", [x, design_position[:y]-20]
      stamp_at "#{details[:design][3]}_mark", [x, design_position[:y]-31]
      stamp_at "#{details[:design][4]}_mark", [x, design_position[:y]-41]
      stamp_at "#{details[:design][5]}_mark", [x, design_position[:y]-52]
      stamp_at "#{details[:design][6]}_mark", [x, design_position[:y]-62]
      stamp_at "#{details[:design][7]}_mark", [x, design_position[:y]-72]
      stamp_at "#{details[:design][8]}_mark", [x, design_position[:y]-93]
      stamp_at "#{details[:design][9]}_mark", [x, design_position[:y]-114]
      stamp_at "#{details[:design][10]}_mark", [x, design_position[:y]-134]
      stamp_at "#{details[:design].inject(:+)}_mark", [x, design_position[:y]-155]
    end
  end

  def self.generate_part_two(details)

    check_details(details)
    
    # write to json file for later retrieval
    File.open("data/#{details[:student_number]}_part2.json","w") do |f|
      f.write(details.to_json)
    end
    
    Prawn::Document.generate(details[:output_filename],
    :template => details[:input_filename]) do
        
      0.upto(100) do |stamp_number|
        create_stamp("#{stamp_number}_mark") do
          draw_text stamp_number.to_s, :at => [0, 0]
        end
      end
      
      create_stamp("minus") do
        draw_text "-", :at => [-5, 0]
      end
      
      go_to_page(2)

      x = 385
      y = 660
      
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
      
      if code_listing_total_marks < 0
        stamp_at("#{code_listing_total_marks*-1}_mark", [x, code_listing_y-125])
        stamp_at("minus", [x, code_listing_y-125] )
      else
        stamp_at("#{code_listing_total_marks}_mark", [x, code_listing_y-125])
      end
      
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
      if mcpi_total_marks < 0
        stamp_at("#{mcpi_total_marks*-1}_mark", [x, mcpi_y-81])
        stamp_at("minus", [x, mcpi_y-81])
      else
        stamp_at("#{mcpi_total_marks}_mark", [x, mcpi_y-81])
      end
    end # Prawn::Document.generate
  end
  
  def self.generate_summary_part_two(details)
    
    check_details(details)
    
    # remove negative marks
    code_listing = 0
    0.upto(8) do |question|
      code_listing += details[:code_listing][question]
    end
    9.upto(10) do |penalty|
      code_listing -= details[:code_listing][penalty]
    end
    
    mcpi = 0
    0.upto(3) do |question|
      mcpi += details[:mcpi][question]
    end
    mcpi -= details[:mcpi][4]
    
    summary_details = { :marker_name => details[:marker_name],
      :student_number => details[:student_number],
      :implementation => details[:implementation].inject(:+),
      :code_listing => code_listing,
      :testing_and_verification => details[:testing_and_verification].inject(:+),
      :user_manual => details[:user_manual].inject(:+),
      :mcpi => mcpi,
      :input_filename => details[:input_filename],
      :output_filename => details[:output_filename]
    }
      
      Prawn::Document.generate(summary_details[:output_filename], :template => summary_details[:input_filename]) do
        create_stamp("marker_name") do
          draw_text summary_details[:marker_name], :at => [0, 0]
        end
        
        create_stamp("student_number") do
          draw_text summary_details[:student_number], :at => [0, 0]
        end
        
        create_stamp("minus") do
          draw_text "-", :at => [-5, 0]
        end
        
        0.upto(100) do |stamp_number|
          create_stamp("#{stamp_number}_mark") do
            draw_text stamp_number.to_s, :at => [0, 0]
          end
        end
        
        stamp_at("student_number", [235,652])
        stamp_at("marker_name", [90,627])
        
        totals_x_position = 380
        
        # Implementation Report and Code Listing
        icl = summary_details[:implementation] +
          summary_details[:code_listing]
        
        if icl < 0
          stamp_at("#{icl*-1}_mark", [totals_x_position,520])
          stamp_at("minus", [totals_x_position,520])
        else
          stamp_at("#{icl}_mark", [totals_x_position,520])
        end
        # Testing and Verification and User Manual
        tv_ui = summary_details[:testing_and_verification] +
          summary_details[:user_manual]
        stamp_at("#{tv_ui}_mark", [totals_x_position,503])
        
        # Maturity, Consistency, Presentation and Innovation
        if summary_details[:mcpi] < 0
          stamp_at("minus", [totals_x_position,484])
          stamp_at("#{summary_details[:mcpi]*-1}_mark",
            [totals_x_position,484])
        else
          stamp_at("#{summary_details[:mcpi]}_mark",
            [totals_x_position,484])
        end
        
    end
  end
  
  def self.generate_summary_part_one(details)
    check_details(details)
    
    summary_details = { :marker_name => details[:marker_name],
    :student_number => details[:student_number],
    :requirements => details[:requirements].inject(:+),
    :analysis => details[:analysis].inject(:+),
    :specification => details[:specification].inject(:+),
    :design => details[:design].inject(:+),
    :input_filename => details[:input_filename],
    :output_filename => details[:output_filename]
    }
    
    Prawn::Document.generate(summary_details[:output_filename], :template => summary_details[:input_filename]) do
      create_stamp("marker_name") do
        draw_text summary_details[:marker_name], :at => [0, 0]
      end
      
      create_stamp("student_number") do
        draw_text summary_details[:student_number], :at => [0, 0]
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
      ras = summary_details[:requirements] +
        summary_details[:analysis] +
        summary_details[:specification]
      stamp_at("#{ras}_mark", [totals_x_position,557])
      
      p summary_details[:design]
      # Design
      stamp_at("#{summary_details[:design]}_mark",
        [totals_x_position, 540])
    end
  end

end

