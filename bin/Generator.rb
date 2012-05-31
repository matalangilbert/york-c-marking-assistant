class Generator
  require_relative 'DataFiles'
  require_relative 'ReportMarker'
  
  def initialize(data_directory)
    @data_directory = data_directory
    
    @data = DataFiles.new(@data_directory)
  end
  
  def generate
      all_student_data(@data_directory).each do |student_data|

      ReportMarker.output_directory = "/home/mat/Documents/C Marking"
      ReportMarker.generate_marksheet(student_data)
      ReportMarker.generate_summary(student_data)
    end
  end
  
  def all_student_data(data_directory)
    Dir.chdir data_directory
    students_data = Array.new
    @data.student_numbers.each do |student|
      students_data << load_student_data(student)
    end
    students_data
  end
  
  def load_student_data(student_number)
    details = Hash.new
    
    unless @data.part_one_details(student_number).nil?
      details.merge!(@data.part_one_details(student_number))
    end
    unless @data.part_two_details(student_number).nil?
      details.merge!(@data.part_two_details(student_number))
    end
    unless @data.demonstration_details(student_number).nil?
      details.merge!(@data.demonstration_details(student_number))
    end
  end
  
end