class DataFiles
  require 'json'
  
  def initialize(data_directory)
    @data_directory = data_directory
    Dir.chdir(@data_directory)
  end
  
  def student_numbers
    numbers = Array.new
    Dir.glob("*.json").each do |file|
      numbers << file.split("_")[0]
    end
    numbers.uniq
  end
  
  def part_one_details(student_number)
    details = Hash.new
    if File.exists? "#{student_number}_part1.json"
      File.open("#{student_number}_part1.json", 'r') do |f|
        details = JSON.parse(f.read, :symbolize_names => true)
      end
    end
    details
  end
  
  def part_two_details(student_number)
    details = Hash.new
    if File.exists? "#{student_number}_part2.json"
      File.open("#{student_number}_part2.json", 'r') do |f|
        details = JSON.parse(f.read, :symbolize_names => true)
      end
    end
    details
  end
  
  def demonstration_details(student_number)
    details = Hash.new
    if File.exists? "#{student_number}_demonstration.json"
      File.open("#{student_number}_demonstration.json", 'r') do |f|
        details = JSON.parse(f.read, :symbolize_names => true)
      end
    end
    details
  end
  
end