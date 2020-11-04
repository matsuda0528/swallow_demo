require 'benchmark'
class Encode
  def initialize
  end

  def generate_cnf(cyllabus)
    @cnf = CNF.new(cyllabus)
    cnf_file_path = File.expand_path("../../tmp/output.cnf",__FILE__)
    Benchmark.bm 10 do |r|

      #対象学年を考慮
      r.report "grade" do
        cyllabus.list.each_with_index do |lec,i|
          TIMETABLESIZE.times do |j|
            if (j%16)/4+1 != lec.grade
              @cnf.add_clauses([((j+1)+i*TIMETABLESIZE)*(-1)])
              lec.availables[j] = nil
            end
          end
        end
        #puts "Generated ristriction of grade"
        #puts "Total of the clauses"+@cnf.clause_count.to_s
      end

      #開催学期を考慮
      r.report "term" do
        cyllabus.list.each_with_index do |lec,i|
          TIMETABLESIZE.times do |j|
            if j/80+1 != lec.term
              @cnf.add_clauses([((j+1)+i*TIMETABLESIZE)*(-1)])
              lec.availables[j] = nil
            end
          end
        end
      end

      #水曜の5〜8限は授業なし
      r.report "Wednessday" do
        cyllabus.list.each_with_index do |lec,i|
          4.times do |j|
            8.times do |k|
              @cnf.add_clauses([-1*(k+35+(k/2)%4*2+j*80+i*TIMETABLESIZE)])
              lec.availables[k+34+(k/2)%4*2+j*80] =nil
            end
          end
        end
      end

      #その他授業なし(教養必修のため)
      r.report "buried" do
        buried_list = [1,3,23,33,49,50,65,81,83,103,129,130,163,183,210,211,234,243,263,289,]#1~TIMETABLESIZE
        cyllabus.list.each_with_index do |lec,i|
          buried_list.each do |e|
            @cnf.add_clauses([-1*(e+i*TIMETABLESIZE)])
            lec.availables[e-1] =nil
          end
        end
      end


      #3年2学期は必修なし
      r.report "term 2" do
        cyllabus.list.each_with_index do |lec,i|
          if lec.required? and lec.grade == 3
            80.times do |j|
              @cnf.add_clauses([-1*(81+j+i*TIMETABLESIZE)])
              lec.availables[80+j] = nil
            end
          end
        end
      end

      #1コマに2つ以上の授業が入らない
      r.report "cells" do
        TIMETABLESIZE.times do |i|
          tmp_list = []
          cyllabus.list.each_with_index do |lec,j|
            if lec.availables[i]
              tmp_list.append (i+1)+j*TIMETABLESIZE
            end
          end
          tmp_list.combination(2).each do |e|
            @cnf.add_clauses(e.map{|l| -1*l})
          end
        end
        #puts "Generated ristriction of cells"
        #puts "Total of the clauses"+@cnf.clause_count.to_s
      end

      #各授業はたかだか一回開催される
      r.report "class" do
        cyllabus.list.each_with_index do |lec,i|
          tmp_list = []
          lec.availables.each do |j|
            if(j)
              tmp_list.append (j+1)+i*TIMETABLESIZE
            end
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


      #先生の重複を考慮
      r.report "instructors" do
        cyllabus.all_instructors.each do |instrctr|
          tmp_list = []
          cyllabus.list.each_with_index do |lec,i|
            if lec.include?(instrctr)
              tmp_list.append(i)
            end
          end
          80.times do |i|
            tmp_list_2 = []
            4.times do |j|
              tmp_list.each do |e|
                next if cyllabus.list[e].availables[i+j*4+(i/4)*12] == nil
                tmp_list_2.append((i+j*4+1)+(i/4)*12+(TIMETABLESIZE*e))
              end
              tmp_list_2.combination(2).each do |e|
                @cnf.add_clauses(e.map{|l| -1*l})
              end
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
          80.times do |i|
            tmp_list_2 = []
            4.times do |j|
              tmp_list.each do |e|
                next if cyllabus.list[e].availables[i+j*4+(i/4)*12] == nil
                tmp_list_2.append((i+j*4+1)+(i/4)*12+(TIMETABLESIZE*e))
              end
              tmp_list_2.combination(2).each do |e|
                @cnf.add_clauses(e.map{|l| -1*l})
              end
            end
          end
        end
        #puts "Generated ristriction of classrooms"
        #puts "Total of the clauses"+@cnf.clause_count.to_s
      end

      #必修の重複を考慮
      #r.report "required" do
      #  tmp_list = []
      #  cyllabus.list.each_with_index do |lec,i|
      #    if lec.required?
      #      tmp_list.append(i)
      #    end
      #  end
      #  160.times do |i|
      #    tmp_list_2 = []
      #    4.times do |j|
      #      tmp_list.each do |e|
      #        next if cyllabus.list[e].availables[i+j*8+(i/8)*24] == nil
      #        tmp_list_2.append((i+j*8+1)+(i/8)*24+(TIMETABLESIZE*e))
      #      end
      #      tmp_list_2.combination(2).each do |e|
      #        @cnf.add_clauses(e.map{|l| -1*l})
      #      end
      #    end
      #  end
      #end

    end#Benckmark.bm end

    File.open(cnf_file_path,"w") do |f|
      f.write(@cnf.text)
    end

    return cnf_file_path
  end

  def generate_csp(cyllabus)

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
      clause
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
