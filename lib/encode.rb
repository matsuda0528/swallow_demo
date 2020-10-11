class Encode
  def initialize
  end

  def generate_cnf(cyllabus)
    @cnf = CNF.new(cyllabus)
    cnf_file_path = File.expand_path("../../tmp/output.cnf",__FILE__)

    #1コマに2つ以上の授業が入らない
    TIMETABLESIZE.times do |i|
      tmp_list = []#RENAME: ある時限に開講されるすべての授業(1 41 81 ..)
      cyllabus.size.times do |j|
        tmp_list.append (i+1)+j*TIMETABLESIZE
      end
      tmp_list.combination(2).each do |e|
        @cnf.add_clauses(e.map{|l| -1*l})
      end
    end

    #各授業は1回以上開催される
    cyllabus.size.times do |i|
      @cnf.add_clauses(((TIMETABLESIZE*i)+1...TIMETABLESIZE*(i+1)).to_a)
    end

    File.open(cnf_file_path,"w") do |f|
      f.write(@cnf.cnf_text)
    end
    return cnf_file_path
  end

  class CNF#NOTE: WCNFクラスを作る
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

    def add_clauses_with_weight (clauses,weight)
      clause = weight.to_s << " "
      clauses.each do |e|
        clause << e << " "
      end
      clause << '0'
      @cnf.append clause
    end

    def cnf_text
      str = "p cnf #{@variabe_count} #{@clause_count}\n"
      @cnf.each do |e|
        str << e << "\n"
      end
      str
    end

    def wcnf_text
    end
  end
end
