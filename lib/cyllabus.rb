require "csv"

class Cyllabus
  def initialize(lecs=nil)
    @lectures = []
    if lecs
      lecs.each do |e|
        @lectures.append(e)
      end
    end
  end

  def load_from(cyllabus_file)
    CSV.foreach(cyllabus_file) do |row|
      @lectures.append(Lecture.new(row))
    end
  end

  def filter_by_term (term)
    Cyllabus.new(@lectures.select {|lec| lec.term == term})
  end

  def list
    @lectures
  end

  class Lecture
    attr_reader :id
    attr_reader :name
    attr_reader :instructors
    attr_reader :term
    attr_reader :grade
    attr_accessor :period

    def initialize(lec_info)
      @id = lec_info[0]
      @name = lec_info[1]
      @instructors = lec_info[2].split
      @term = lec_info[3].to_i
      @grade = lec_info[4].to_i
      @period = nil
    end
  end
end
