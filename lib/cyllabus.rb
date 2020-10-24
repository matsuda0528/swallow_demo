require "csv"
require "json"

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

  def filter_by_term (term)#NOTE: 今の所不要
    Cyllabus.new(@lectures.select {|lec| lec.term == term})
  end

  def subdivide_by_required_time
    tmp_lectures = []
    @lectures.each_with_index do |e,i|
      e.required_time.times do
        tmp_lectures.append(e.clone)
      end
    end
    Cyllabus.new(tmp_lectures)
  end

  def list
    @lectures
  end

  def size
    @lectures.size
  end

  def all_instructors
    all_instrctrs = []
    @lectures.each do |lec|
      lec.instructors.each do |e|
        unless all_instrctrs.include? e
          all_instrctrs.append e
        end
      end
    end
    all_instrctrs
  end

  def all_rooms
    all_rms = []
    @lectures.each do |lec|
      lec.rooms.each do |e|
        unless all_rms.include? e
          all_rms.append e
        end
      end
    end
    all_rms
  end

  def to_json
    hash = {}
    @lectures.each_with_index do |e,i|
      hash["Lecture#{i}"] = e.to_hash
    end
    JSON.generate(hash)
  end

  class Lecture
    attr_reader :id
    attr_reader :name
    attr_reader :instructors
    attr_reader :term
    attr_reader :grade
    attr_reader :required_time
    attr_reader :rooms
    attr_reader :type
    attr_accessor :period
    attr_accessor :period_id#0-時間割コマ数-1
    attr_accessor :availables

    def initialize(lec_info)
      @id = lec_info[0]
      @name = lec_info[1]
      @instructors = lec_info[2].split
      @term = lec_info[3].to_i
      @grade = lec_info[4].to_i
      @required_time = lec_info[5].to_i
      @rooms = lec_info[6].split
      @type = lec_info[7]
      @period = nil
      @period_id = nil
      @availables = (1..640).to_a
    end

    def to_hash
      {
        :id => @id,
        :name => @name,
        :instructors => @instructors,
        :term => @term,
        :grade => @grade,
        :required_time => @required_time,
        :rooms => @rooms,
        :type => @type,
        :period => @period,
        :period_id => @period_id
      }
    end

    def include?(elem)
      @instructors.include?(elem) || @rooms.include?(elem)
    end

    def required?
      self.type == "必修" or "必修選択"
    end
  end
end
