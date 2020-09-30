#def parse(cyllabus.csv)
#return hash or obj
require "csv"

class Cyllabus
  def initialize(cyllabus_file)
    @lectures = []
    CSV.foreach(cyllabus_file) do |row|
      @lectures.append(Lecture.new(row))
    end
  end

  class Lecture
    attr_reader :id
    attr_reader :name
    attr_reader :instructors
    attr_reader :term
    attr_reader :grade

    def initialize(lec_info)
      @id = lec_info[0]
      @name = lec_info[1]
      @instructors = lec_info[2].split
      @term = lec_info[3].to_i
      @grade = lec_info[4].to_i
    end
  end
end
