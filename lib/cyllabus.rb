require "csv"
require "json"
require "xmlsimple"

class Cyllabus
  # attr_reader :continuous_lectures
  # attr_reader :discontinuous_lectures
  attr_reader :lectures
  attr_reader :rooms
  attr_reader :dists
  attr_reader :dnrvars

  def initialize
    @lectures = Array.new
    @rooms = Array.new
    @dists = Array.new
    @dnrvars = [0]
  end
  # def initialize(lecs=nil)
  #   @lectures = []
  #   @continuous_lectures = []
  #   @discontinuous_lectures = []
  #   if lecs
  #     lecs.each do |lec|
  #       @lectures.append(lec)
  #     end
  #   end
  # end

  def load_xml(xml_file)
    hash = XmlSimple.xml_in(open(xml_file))

    hash["rooms"].each do |rooms|
      @rooms = rooms["room"]
    end

    hash["courses"].each do |course|
      course["course"].each do |config|
        config["config"].each do |subpart|
          subpart["subpart"].each do |lectures|
            lectures["class"].each do |lec|
              @lectures.push lec
              @dnrvars.push(@dnrvars.last + lec["time"].size)
            end
          end
        end
      end
    end

    hash["distributions"].each do |distribution|
      @dists = distribution["distribution"]
    end
    # pp @rooms.size
    # pp @classes.size
  end

  # def filter_by_term (term)#NOTE: 今の所不要
  #   Cyllabus.new(@lectures.select {|lec| lec.term == term})
  # end

  # def subdivide_by_required_time
  #   tmp_lectures = []
  #   @lectures.each_with_index do |e,i|
  #     ((e.required_time+1)/2).times do
  #       tmp_lectures.append(e.clone)
  #     end
  #   end
  #   @lectures = tmp_lectures
  # end

  # def generate_continuous_lectures
  #   tmp = []
  #   continuous_flag = 0
  #   discontinuous_flag = 0
  #   flagflag = 0
  #   @lectures.each do |lec|
  #     if continuous_flag == 1
  #       tmp.append lec
  #       @continuous_lectures.append tmp
  #       tmp = []
  #       continuous_flag = 0
  #       if lec.required_time == 8 and flagflag == 0
  #         tmp.append lec
  #         discontinuous_flag = 1
  #         flagflag = 1
  #       else
  #         flagflag = 0
  #       end
  #       next
  #     end

  #     if discontinuous_flag == 1
  #       tmp.append lec
  #       @discontinuous_lectures.append tmp
  #       tmp = []
  #       discontinuous_flag = 0
  #       next if flagflag == 0
  #     end

  #     if (lec.continuous+1)/2 == 2
  #       tmp.append lec
  #       continuous_flag = 1
  #     end

  #     if (lec.continuous+1)/2 == 1 and lec.required_time >= 4
  #       tmp.append lec
  #       discontinuous_flag = 1
  #     end
  #   end
  # end

  # def set_inner_id
  #   @lectures.each_with_index do |lec,id|
  #     lec.inner_id = id
  #   end
  # end

  # def list
  #   @lectures
  # end

  # def size
  #   @lectures.size
  # end

  # def all_instructors
  #   all_instrctrs = []
  #   @lectures.each do |lec|
  #     lec.instructors.each do |e|
  #       unless all_instrctrs.include? e
  #         all_instrctrs.append e
  #       end
  #     end
  #   end
  #   all_instrctrs
  # end

  # def all_rooms
  #   all_rms = []
  #   @lectures.each do |lec|
  #     lec.rooms.each do |e|
  #       unless all_rms.include? e
  #         all_rms.append e
  #       end
  #     end
  #   end
  #   all_rms
  # end

  # def to_json
  #   hash = {}
  #   @lectures.each_with_index do |e,i|
  #     hash["Lecture#{i}"] = e.to_hash
  #   end
  #   JSON.generate(hash)
  # end

  # class Class
  #   def initialize
  #     @id<int>
  #     @limit<int>
  #     @parent<Class>
  #     @time<Time>
  #     @room[{id=>int, penalty=>int}]
  #   end
  # end

  # class Room
  #   def initialize
  #     @id<int>
  #     @capacity<int>
  #     @unavailable<array>
  #   end
  # end

  # class Time
  #   def initialize
  #     @start
  #     @length<int>
  #     @days
  #     @weeks
  #     @semesters
  #     @grades
  #   end
  # end
  # class Lecture
  #   attr_reader :id
  #   attr_reader :name
  #   attr_reader :instructors
  #   attr_reader :term
  #   attr_reader :grade
  #   attr_reader :required_time
  #   attr_reader :rooms
  #   attr_reader :type
  #   attr_reader :continuous
  #   attr_accessor :period
  #   attr_accessor :period_id#0-時間割コマ数-1
  #   attr_accessor :availables
  #   attr_accessor :inner_id

  #   def initialize(lec_info)
  #     @id = lec_info[0]
  #     @name = lec_info[1]
  #     @instructors = lec_info[2].split
  #     @term = lec_info[3].to_i
  #     @grade = lec_info[4].to_i
  #     @required_time = lec_info[5].to_i
  #     @rooms = lec_info[6].split
  #     @type = lec_info[7]
  #     @continuous = lec_info[8].to_i
  #     @period = nil
  #     @period_id = nil
  #     @availables = (1..320).to_a
  #     @inner_id = 0
  #   end

  #   def to_hash
  #     {
  #       :id => @id,
  #       :name => @name,
  #       :instructors => @instructors,
  #       :required_time => @required_time,
  #       :rooms => @rooms,
  #       :type => @type,
  #       :period => @period,
  #       :period_id => @period_id
  #     }
  #   end

  #   def include?(elem)
  #     @instructors.include?(elem) || @rooms.include?(elem)
  #   end

  #   def required?
  #     self.type == "必修" or self.type == "必修選択"
  #   end
  # end
end
