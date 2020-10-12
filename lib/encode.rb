require 'benchmark'
class Encode
  def initialize
  end

  def generate_cnf(cyllabus)
    @cnf = CNF.new(cyllabus)
    cnf_file_path = File.expand_path("../../tmp/output.cnf",__FILE__)
    Benchmark.bm 10 do |r|

    #1コマに2つ以上の授業が入らない
    #OPTIMIZE: 生成される節が多すぎる，対象学年から省略可能
    r.report "cells" do
    TIMETABLESIZE.times do |i|
      tmp_list = []
      cyllabus.size.times do |j|
        tmp_list.append (i+1)+j*TIMETABLESIZE
      end
      tmp_list.combination(2).each do |e|
        @cnf.add_clauses(e.map{|l| -1*l})
      end
    end
    #puts "Generated ristriction of cells"
    #puts "Total of the clauses"+@cnf.clause_count.to_s
    end

    #各授業は1回以上開催される
    r.report "class exist" do
    cyllabus.size.times do |i|
      @cnf.add_clauses(((TIMETABLESIZE*i)+1...TIMETABLESIZE*(i+1)).to_a)
    end
    #puts "Generated ristriction of class exist"
    #puts "Total of the clauses"+@cnf.clause_count.to_s
    end

    #対象学年を考慮
    r.report "grade" do
    cyllabus.list.each_with_index do |e,i|
      TIMETABLESIZE.times do |j|
        if (j%32)/8+1 != e.grade
          @cnf.add_clauses([((j+1)+i*TIMETABLESIZE)*(-1)])
        end
      end
    end
    #puts "Generated ristriction of grade"
    #puts "Total of the clauses"+@cnf.clause_count.to_s
    end

    #先生の重複を考慮
    r.report "instructors" do
    cyllabus.all_instructors.each do |instrctr|
      tmp_list = []
      cyllabus.list.each_with_index do |lec,i|
        if lec.include?(instrctr)
          tmp_list.append(i)
        end
      end
      160.times do |i|
        tmp_list_2 = []
        tmp_list.each do |e|
          tmp_list_2.append((i+1)+(i/8)*24+(TIMETABLESIZE*e))
          tmp_list_2.append((i+9)+(i/8)*24+(TIMETABLESIZE*e))
          tmp_list_2.append((i+17)+(i/8)*24+(TIMETABLESIZE*e))
          tmp_list_2.append((i+25)+(i/8)*24+(TIMETABLESIZE*e))
        end
        tmp_list_2.combination(2).each do |e|
          @cnf.add_clauses(e.map{|l| -1*l})
        end
      end
    end
    #puts "Generated ristriction of instructors"
    #puts "Total of the clauses"+@cnf.clause_count.to_s
    end


    #教室の重複を考慮
    r.report "classroom" do
    cyllabus.all_rooms.each do |rm|
      tmp_list = []
      cyllabus.list.each_with_index do |lec,i|
        if lec.include?(rm)
          tmp_list.append(i)
        end
      end
      160.times do |i|
        tmp_list_2 = []
        tmp_list.each do |e|
          tmp_list_2.append((i+1)+(i/8)*24+(TIMETABLESIZE*e))
          tmp_list_2.append((i+9)+(i/8)*24+(TIMETABLESIZE*e))
          tmp_list_2.append((i+17)+(i/8)*24+(TIMETABLESIZE*e))
          tmp_list_2.append((i+25)+(i/8)*24+(TIMETABLESIZE*e))
        end
        tmp_list_2.combination(2).each do |e|
          @cnf.add_clauses(e.map{|l| -1*l})
        end
      end
    end
    #puts "Generated ristriction of classrooms"
    #puts "Total of the clauses"+@cnf.clause_count.to_s
    end

    #水曜の5〜8限は授業なし
    r.report "Wednessday" do 
    cyllabus.size.times do |i|
      4.times do |j|
        16.times do |k|
          @cnf.add_clauses([-1*(k+69+(k/4)%4*4+j*160+i*TIMETABLESIZE)])
        end
      end
    end
    end
    end#Benckmark.bm end

    File.open(cnf_file_path,"w") do |f|
      f.write(@cnf.text)
    end
    return cnf_file_path
  end

  class CNF
    attr_reader :clause_count#デバッグ用
    def initialize(cyllabus)
      @cnf = []
      @clause_count = 0
      @variabe_count = cyllabus.size * TIMETABLESIZE
    end

    def add_clauses (clauses)
      clause = ""
      clauses.each do |e|
        clause << e.to_s << " "
      end
      clause << '0'
      @cnf.append clause
      @clause_count += 1
    end

    def text
      str = "p cnf #{@variabe_count} #{@clause_count}\n"
      @cnf.each do |e|
        str << e << "\n"
      end
      str
    end
  end

  class WCNF
    def initialize(cyllabus)
      @cnf = []
      @clause_count = 0
      @variabe_count = cyllabus.size * TIMETABLESIZE
    end

    def add_clauses_with_weight (clauses,weight)
      clause = weight.to_s << " "
      clauses.each do |e|
        clause << e << " "
      end
      clause << '0'
      @cnf.append clause
    end

    def text
    end
  end
end
