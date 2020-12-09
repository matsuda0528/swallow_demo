require 'benchmark'
class Encode
  def initialize
  end

  def generate_cnf(cyllabus)
    @wcnf = WCNF.new
    wcnf_file_path = File.expand_path("../../tmp/output.wcnf")

    # 授業が持つtimeについてのamo,alo
    cyllabus.lectures.each_with_index do |lec,i|
      literals = []
      lec["time"].size.times do |j|
        literals.append (j+1)+cyllabus.dnrvars[i]
        p (j+1)+cyllabus.dnrvars[i]
      end
      @wcnf.add_hard_amo(literals)
      @wcnf.add_hard_alo(literals)
    end

    # distribution制約
    cyllabus.dists.each_with_index do |dist,i|
      case dist["type"]
      when "SameStart" then
        self.same_start(dist["class"], dist["penalty"])
      when "SameTime" then
        self.same_time(dist["class"], dist["penalty"])
      when "DifferentTime" then
        self.different_time(dist["class"], dist["penalty"])
      when "SameDays" then
        self.same_days(dist["class"], dist["penalty"])
      when "DifferentDays" then
        self.different_days(dist["class"], dist["penalty"])
      when "SameWeeks" then
        self.same_weeks(dist["class"], dist["penalty"])
      when "DifferentWeeks" then
        self.different_weeks(dist["class"], dist["penalty"])
      when "SameRoom" then
        self.same_room(dist["class"], dist["penalty"])
      when "DifferentRoom" then
        self.different_room(dist["class"], dist["penalty"])
      when "Overlap" then
        self.overlap(dist["class"], dist["penalty"])
      when "NotOverlap" then
        self.not_overlap(dist["class"], dist["penalty"])
      when "SameAttendees" then
        self.same_attendees(dist["class"], dist["penalty"])
      when "Precedence" then
        self.precedence(dist["class"], dist["penalty"])
      when /WorkDay(\d+)/ then
        self.work_day(dist["class"], dist["type"].match(/\d+/), dist["penalty"])
      when /MinGap(\d+)/ then
        self.min_gap(dist["class"], dist["type"].match(/\d+/), dist["penalty"])
      when /MaxDays(\d+)/ then
        self.max_days(dist["class"], dist["type"].match(/\d+/), dist["penalty"])
      when /MaxDayLoad(\d+)/ then
        self.max_day_load(dist["class"], dist["type"].match(/\d+/), dist["penalty"])
      when /MaxBreaks(\d+,\d+)/ then
        self.max_breaks(dist["class"], dist["type"].match(/\d+/), dist["penalty"])
      when /MaxBlock(\d+,\d+)/ then
        self.max_block(dist["class"], dist["type"].match(/\d+/), dist["penalty"])
      end
    end
  end

  def same_start(lectures, penalty)
  end

  def same_time(lectures, penalty)
  end

  def different_time(lectures, penalty)
  end

  def same_days(lectures, penalty)
  end

  def different_days(lectures, penalty)
  end

  def same_weeks(lectures, penalty)
  end

  def different_weeks(lectures, penalty)
  end

  def same_room(lectures, penalty)
  end

  def different_room(lectures, penalty)
  end

  def overlap(lectures, penalty)
  end

  def not_overlap(lectures, penalty)
  end

  def same_attendees(lectures, penalty)
  end

  def precedence(lectures, penalty)
  end

  def work_day(lectures, timeslots, penalty)
  end

  def min_gap(lectures, timeslots, penalty)
  end

  def max_days(lectures, timeslots, penalty)
  end

  def max_day_load(lectures, timeslots, penalty)
  end

  def max_breaks(lectures, timeslots, penalty)
  end

  def max_block(lectures, timeslots, penalty)
  end

  class WCNF
    def initialize
      @hard_clauses = []
      @soft_clauses = []
      @nr_clauses = 0
      @nr_variables = 0
      @sum_penalty = 0
    end
    # def initialize(cyllabus)
    #   @cnf = []
    #   @clause_count = 0
    #   @variabe_count = cyllabus.size * TIMETABLESIZE
    # end
    def add_hard_clause(literals)
      clause = ""
      literals.each do |literal|
        clause << literal << " "
      end
      clause << '0'
      @hard_clauses.append clause
      @nr_clauses += 1
    end

    def add_hard_amo(literals)
      literals.combination(2).each do |l|
        clause = (-1*l[0]).to_s << " " << (-1*l[1]).to_s << " " << "0"
        @hard_clauses.append clause
        @nr_clauses += 1
      end
    end

    def add_hard_alo(literals)
      clause = ""
      literals.each do |l|
        clause << l.to_s << " "
      end
      clause << "0"
      @hard_clauses.append clause
      @nr_clauses += 1
    end

    def add_soft_clause (literals,penalty)
      clause = penalty.to_s << " "
      literals.each do |literal|
        clause << e << " "
      end
      clause << '0'
      @soft_clauses.append clause
      @nr_clauses += 1
      @sum_penalty += penalty
    end

    def add_soft_amo(literals,penalty)
      literals.combination(2).each do |l|
        clause = penalty.to_s << " " << (-1*l[0]).to_s << " " << (-1*l[1]).to_s << " " << "0"
        @soft_clauses.append clause
        @nr_clauses += 1
      end
    end

    def add_soft_alo(literals,penalty)
      clause = penalty.to_s << " "
      literals.each do |l|
        clause << l.to_s << " "
      end
      clause << "0"
      @soft_clauses.append clause
      @nr_clauses += 1
    end

    def text
    end
  end
end

  #def generate_cnf(cyllabus)
  #  @cnf = CNF.new(cyllabus)
  #  cnf_file_path = File.expand_path("../../tmp/output.cnf",__FILE__)
  #  Benchmark.bm 10 do |r|

  #    #対象学年を考慮
  #    r.report "grade" do
  #      cyllabus.list.each_with_index do |lec,i|
  #        TIMETABLESIZE.times do |j|
  #          if (j%16)/4+1 != lec.grade
  #            @cnf.add_literal(((j+1)+lec.inner_id*TIMETABLESIZE)*(-1))
  #            lec.availables[j] = nil
  #          end
  #        end
  #      end
  #    end

  #    #開催学期を考慮
  #    r.report "term" do
  #      cyllabus.list.each_with_index do |lec,i|
  #        TIMETABLESIZE.times do |j|
  #          if j/80+1 != lec.term
  #            @cnf.add_literal(((j+1)+lec.inner_id*TIMETABLESIZE)*(-1))
  #            lec.availables[j] = nil
  #          end
  #        end
  #      end
  #    end

  #    #水曜の5〜8限は授業なし
  #    r.report "Wednessday" do
  #      cyllabus.list.each_with_index do |lec,i|
  #        4.times do |j|
  #          8.times do |k|
  #            @cnf.add_literal(-1*(k+35+(k/2)%4*2+j*80+lec.inner_id*TIMETABLESIZE))
  #            lec.availables[k+34+(k/2)%4*2+j*80] =nil
  #          end
  #        end
  #      end
  #    end

  #    # 7,8限は授業なし
  #    cyllabus.list.each_with_index do |lec,i|
  #      TIMETABLESIZE.times do |j|
  #        if j%4==3
  #          @cnf.add_literal(-1*(j+1+lec.inner_id*TIMETABLESIZE))
  #          lec.availables[j]=nil
  #        end
  #      end
  #    end

  #    #その他授業なし(教養必修のため)
  #    r.report "buried" do
  #      buried_list = [1,3,23,33,49,50,65,81,83,103,129,130,163,183,210,211,234,243,263,289,]#1~TIMETABLESIZE
  #      cyllabus.list.each_with_index do |lec,i|
  #        buried_list.each do |e|
  #          @cnf.add_literal(-1*(e+lec.inner_id*TIMETABLESIZE))
  #          lec.availables[e-1] =nil
  #        end
  #      end
  #    end


  #    #3年2学期は必修なし
  #    r.report "term 2" do
  #      cyllabus.list.each_with_index do |lec,i|
  #        if lec.required? and lec.grade == 3
  #          80.times do |j|
  #            @cnf.add_literal(-1*(81+j+lec.inner_id*TIMETABLESIZE))
  #            lec.availables[80+j] = nil
  #          end
  #        end
  #      end
  #    end

  #    #1コマに2つ以上の授業が入らない
  #    r.report "cells" do
  #      TIMETABLESIZE.times do |i|
  #        literal_set = []
  #        cyllabus.list.each_with_index do |lec,j|
  #          if lec.availables[i]
  #            literal_set.append (i+1)+lec.inner_id*TIMETABLESIZE
  #          end
  #        end
  #        @cnf.add_amo(literal_set)
  #      end
  #    end

  #    #各授業はたかだか一回開催される
  #    r.report "class" do
  #      cyllabus.list.each_with_index do |lec,i|
  #        literal_set = []
  #        lec.availables.each do |j|
  #          if(j)
  #            literal_set.append (j+1)+lec.inner_id*TIMETABLESIZE
  #          end
  #        end
  #        @cnf.add_amo(literal_set)
  #      end
  #    end

  #    #各授業は1回以上開催される
  #    r.report "class exist" do
  #      cyllabus.list.each_with_index do |lec,i|
  #        @cnf.add_alo(((TIMETABLESIZE*lec.inner_id)+1...TIMETABLESIZE*(lec.inner_id+1)).to_a)
  #      end
  #    end

  #    # 授業の連続性を考慮
  #    # HACK: 不要な節が多い
  #    cyllabus.continuous_lectures.each do |lecs|
  #      TIMETABLESIZE.times do |i|
  #        if i%4 == 3
  #          @cnf.add_literal(-1*((i+1)+(TIMETABLESIZE*lecs[0].inner_id)))
  #          lecs[0].availables[i] = nil
  #        end
  #        if i%4 == 0
  #          @cnf.add_literal(-1*((i+1)+(TIMETABLESIZE*lecs[1].inner_id)))
  #          lecs[1].availables[i] = nil
  #        end
  #        # next if lecs[0].availables[i] == nil or lecs[1].availables[i+1] == nil
  #        # XXX: 上記のコメントを外すと制約を満たさない(理由不明)
  #        @cnf.add_clauses([-1*((i+1)+(TIMETABLESIZE*lecs[0].inner_id)),(i+2)+(TIMETABLESIZE*lecs[1].inner_id)])
  #      end
  #    end

  #    # 授業の不連続性を考慮
  #    # HACK: 不要な節が多い
  #    cyllabus.discontinuous_lectures.each do |lecs|
  #      TIMETABLESIZE.times do |i|
  #        #next if lecs[0].availables[i] == nil
  #        # XXX: 上記のコメントを外すと制約を満たさない(理由不明)
  #        tmp = (((i+32)+TIMETABLESIZE*lecs[1].inner_id)..((i+80)+TIMETABLESIZE*lecs[1].inner_id)).to_a
  #        # HACK: 上記の数値は適当
  #        @cnf.add_clauses([-1*((i+1)+TIMETABLESIZE*lecs[0].inner_id)]+tmp)
  #        # 32.times do |j|
  #        #   @cnf.add_clauses([-1*((i+1)+(TIMETABLESIZE*lecs[0].inner_id)),-1*((i+j+2)+(TIMETABLESIZE*lecs[1].inner_id))])
  #        # end
  #      end
  #    end

  #    #先生の重複を考慮
  #    r.report "instructors" do
  #      cyllabus.all_instructors.each do |instrctr|
  #        tmp_list = []
  #        cyllabus.list.each_with_index do |lec,i|
  #          if lec.include?(instrctr)
  #            tmp_list.append(lec)
  #          end
  #        end
  #        80.times do |i|
  #          tmp_list_2 = []
  #          4.times do |j|
  #            tmp_list.each do |lec|
  #              next if cyllabus.list[lec.inner_id].availables[i+j*4+(i/4)*12] == nil
  #              tmp_list_2.append((i+j*4+1)+(i/4)*12+(TIMETABLESIZE*lec.inner_id))
  #            end
  #            @cnf.add_amo(tmp_list_2)
  #          end
  #        end
  #      end
  #    end


  #    #教室の重複を考慮
  #    r.report "classroom" do
  #      cyllabus.all_rooms.each do |rm|
  #        tmp_list = []
  #        cyllabus.list.each_with_index do |lec,i|
  #          if lec.include?(rm)
  #            tmp_list.append(lec)
  #          end
  #        end
  #        80.times do |i|
  #          tmp_list_2 = []
  #          4.times do |j|
  #            tmp_list.each do |lec|
  #              next if cyllabus.list[lec.inner_id].availables[i+j*4+(i/4)*12] == nil
  #              tmp_list_2.append((i+j*4+1)+(i/4)*12+(TIMETABLESIZE*lec.inner_id))
  #            end
  #            @cnf.add_amo(tmp_list_2)
  #          end
  #        end
  #      end
  #    end

  #    #1学期以外の必修の重複を考慮
  #    #XXX: 1学期の必修問題は解けない
  #    r.report "required" do
  #      tmp_list = []
  #      cyllabus.list.each_with_index do |lec,i|
  #        if lec.required?
  #          tmp_list.append(lec)
  #        end
  #      end
  #      80.times do |i|
  #        next if i < 20
  #        tmp_list_2 = []
  #        4.times do |j|
  #          tmp_list.each do |lec|
  #            next if cyllabus.list[lec.inner_id].availables[i+j*4+(i/4)*12] == nil
  #            tmp_list_2.append((i+j*4+1)+(i/4)*12+(TIMETABLESIZE*lec.inner_id))
  #          end
  #          @cnf.add_amo(tmp_list_2)
  #        end
  #      end
  #    end


  #  end#Benckmark.bm end

  #  File.open(cnf_file_path,"w") do |f|
  #    f.write(@cnf.text)
  #  end

  #  return cnf_file_path
  #end

  # class CNF
  #   attr_reader :clause_count#デバッグ用
  #   def initialize(cyllabus)
  #     @cnf = []
  #     @clause_count = 0
  #     @variabe_count = cyllabus.size * TIMETABLESIZE
  #   end

  #   def add_clauses (clauses)
  #     clause = ""
  #     clauses.each do |e|
  #       clause << e.to_s << " "
  #     end
  #     clause << '0'
  #     @cnf.append clause
  #     @clause_count += 1
  #     clause
  #   end

  #   def add_literal (literal)
  #     clause = literal.to_s << " " << "0"
  #     @cnf.append clause
  #     @clause_count += 1
  #   end

  #   def add_amo (literals)
  #     literals.combination(2).each do |l|
  #       clause = (-1*l[0]).to_s << " " << (-1*l[1]).to_s << " " << "0"
  #       @cnf.append clause
  #       @clause_count += 1
  #     end
  #   end

  #   def add_alo (literals)
  #     clause = ""
  #     literals.each do |l|
  #       clause << l.to_s << " "
  #     end
  #     clause << "0"
  #     @cnf.append clause
  #     @clause_count += 1
  #   end

  #   def text
  #     str = "p cnf #{@variabe_count} #{@clause_count}\n"
  #     @cnf.each do |e|
  #       str << e << "\n"
  #     end
  #     str
  #   end
  # end

