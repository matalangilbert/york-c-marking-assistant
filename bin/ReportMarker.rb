class ReportMarker
  require 'prawn'
  require 'json'

  def self.marking_form_input_filename
    "#{assets_dir}/assignment-mark-form.pdf"
  end
  
  def self.summary_input_filename
    "#{assets_dir}/summary-mark-form.pdf"
  end
  
  def self.output_directory
    @output_directory
  end
  
  def self.output_directory=(value)
    @output_directory = value
  end
  
  def self.assets_dir
    assets_root = nil

    # if running as a gem
    Gem::Specification.each do |installed_gem|
      if installed_gem.name == 'yorkcmarker'
        spec = Gem::Specification.find_by_name('yorkcmarker')
        assets_root = spec.gem_dir + "/assets"
      end
    end
    # if running as a script
    if assets_root.nil?
      assets_root = File.dirname(File.dirname(__FILE__)) + "/assets"
    end
    assets_root
  end
  
  def self.marking_form_output_filename(student_number)
    "#{output_directory}/#{student_number}_assignment-mark-form.pdf"
  end
  
  def self.summary_out_output_filename(student_number)
    "#{output_directory}/#{student_number}_summary.pdf"
  end
  
  def self.data_directory
    unless File.directory?("#{output_directory}/data")
      Dir.mkdir("#{output_directory}/data")
    end
    "#{output_directory}/data"
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
  
  def self.generate_marksheet(details)
    x = 385
    total_mark_position = {:y => 660}
    requirements_position = {:y => 582}
    analysis_position = {:y => 522}
    specification_position = {:y => 411}
    design_position = {:y => 342}
    
    Prawn::Document.generate(self.marking_form_output_filename(details[:student_number]), :template => self.marking_form_input_filename) do
      
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
      
      # Lateness
        #unless details[:lateness].empty?
          #stamp_at "minus", [x, total_mark_position[:y]-20]
          #stamp_at "#{details[:lateness]}_mark", [x, total_mark_position[:y]-20]
        #end
      
      unless details[:requirements].nil?
        # Details
        stamp_at "marker_name", [85, total_mark_position[:y]]
        stamp_at "student_number", [215, total_mark_position[:y]-10]
        stamp_at "date", [77, total_mark_position[:y]-21]
        
        part_one_total_mark = details[:requirements].inject(:+) +
          details[:analysis].inject(:+) +
          details[:specification].inject(:+) +
          details[:design].inject(:+)
        
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
      
      go_to_page(2)

      x = 385
      y = 660
      
      unless details[:implementation].nil?
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
        
        part_two_total_mark = details[:implementation].inject(:+) +
          code_listing_total_marks +
          details[:testing_and_verification].inject(:+) +
          details[:user_manual].inject(:+) +
          mcpi_total_marks
        
      end
      
      # Demonstration
      unless details[:demonstration_mark].nil?
        stamp_at("#{details[:demonstration_mark]}_mark",
          [x, 106])
      end
      
     # Total Mark
      total_mark = 0
      
      total_mark += part_one_total_mark unless part_one_total_mark.nil?
      total_mark += part_two_total_mark unless part_two_total_mark.nil?
      unless details[:demonstration_mark].nil?
        total_mark += details[:demonstration_mark]
      end
       
      go_to_page(1)
      stamp_at "#{total_mark}_mark", [x, total_mark_position[:y]]
      details[:total_mark] = total_mark
    end
    puts "generated: #{details[:student_number]}\tmarksheet"
  end
  
  def self.generate_summary(details)
    summary_details = { :marker_name => details[:marker_name],
      :student_number => details[:student_number]
    }

    # part one
    unless details[:requirements].nil?
      # Requirements, Analysis and Specification
      ras = details[:requirements].inject(:+) +
        details[:analysis].inject(:+) +
        details[:specification].inject(:+)
      summary_details[:ras] = ras
      summary_details[:design] = details[:design].inject(:+)
    end
    
    # part two
    unless details[:implementation].nil?
      # remove negative marks
      unless details[:code_listing].nil?
        code_listing = 0
        0.upto(8) do |question|
          code_listing += details[:code_listing][question]
        end
        9.upto(10) do |penalty|
          code_listing -= details[:code_listing][penalty]
        end
      end
      summary_details[:ir_cl] = details[:implementation].inject(:+)
        + code_listing
     
      summary_details[:tv_ui] = details[:testing_and_verification].inject(:+) +
        details[:user_manual].inject(:+)
      
      mcpi = 0
      0.upto(3) do |question|
        mcpi += details[:mcpi][question]
      end
      mcpi -= details[:mcpi][4]
      summary_details[:mcpi] = mcpi
    end
    
    # Demonstration
    unless details[:demonstration_mark].nil?
      summary_details[:demonstration] = details[:demonstration_mark]
    end
      

    Prawn::Document.generate(self.summary_out_output_filename(details[:student_number]),
    :template => self.summary_input_filename) do
      create_stamp("marker_name") do
        draw_text summary_details[:marker_name], :at => [0, 0]
      end
      
      create_stamp("student_number") do
        draw_text summary_details[:student_number], :at => [0, 0]
      end
    
      # integer marks
      0.upto(100) do |stamp_number|
        create_stamp("#{stamp_number}_mark") do
          draw_text stamp_number.to_s, :at => [0, 0]
        end
      end
      
      # half marks for contribution
      (0..100).step(0.5) do |stamp_number|
        create_stamp("#{stamp_number}_mark") do
          draw_text stamp_number.to_s, :at => [0, 0]
        end
      end
      
      stamp_at("student_number", [235,652])
      stamp_at("marker_name", [90,627])
      
      totals_x_position = 380
      # Part One
      # Requirements, Analysis and Specification]
      unless summary_details[:ras].nil?
        stamp_at("#{summary_details[:ras]}_mark", [totals_x_position,557])
        # Design
        stamp_at("#{summary_details[:design]}_mark",
          [totals_x_position, 540])
      end
      
      # Part Two
      unless summary_details[:ir_cl].nil?
        # Implementation Report and Code Listing
        if summary_details[:ir_cl] < 0
          stamp_at("#{summary_details[:ir_cl]*-1}_mark",
            [totals_x_position,520])
          stamp_at("minus", [totals_x_position,520])
        else
          stamp_at("#{summary_details[:ir_cl]}_mark", [totals_x_position,520])
        end
        
        # Testing and Verification and User Manual
        stamp_at("#{summary_details[:tv_ui]}_mark", [totals_x_position,503])
        
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
      
      # Demonstration
      unless summary_details[:demonstration].nil?
        stamp_at("#{summary_details[:demonstration]}_mark",
          [totals_x_position, 466])
      end
      
      # Total
      total_mark = 0
      # Part One
      total_mark += summary_details[:ras] unless summary_details[:ras].nil?
      total_mark += summary_details[:design]
      # Part Two
      unless summary_details[:implementation].nil?
        total_mark += summary_details[:ir_cl]
        total_mark += summary_details[:tv_ui]
        total_mark += summary_details[:mcpi]
      end
      # Demonstration
      unless summary_details[:demonstration].nil?
        total_mark += summary_details[:demonstration]
      end
      
      # Stamp totals
=begin
      stamp_at("#{total_mark}_mark",
        [totals_x_position, 450])
        
      # Contribution to Digital Electronics
      stamp_at("#{total_mark.to_f/2}_mark",
        [totals_x_position, 431])
=end
    end
    
    puts "generated: #{details[:student_number]}\tsummary"
  end
  


  def self.save_demonstration_mark(details)
    # write to json file for later retrieval
    File.open("#{data_directory}/#{details[:student_number]}_demonstration.json","w") do |f|
      f.write(details.to_json)
    end
  end
  
end

