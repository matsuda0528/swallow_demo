class Encode
  def initialize
  end

  def generate_cnf(cyllabus)
    @cnf = CNF.new(cyllabus)
    cnf_file_path = "output.cnf"

    40.times do |i|#RENAME: 40は時間割のコマ数
      tmp_list = []#RENAME: ある時限に開講されるすべての授業(1 41 81 ..)
      cyllabus.list.size.times do |j|
        tmp_list.append (i+1)+j*40
      end
      tmp_list.combination(2).each do |e|
        @cnf.add_clauses(e.map{|l| -1*l})
      end
    end

    File.open(cnf_file_path,"w") do |f|#FIXME: tmpに出力する
      f.write(@cnf.cnf_text)
    end
    return cnf_file_path
  end

  class CNF#NOTE: WCNFクラスを作る
    def initialize(cyllabus)
      @cnf = []
      @clause_count = 0
      @variabe_count = cyllabus.list.size * 40#RENAME: 40は時間割のコマ数
    end

    def add_clauses (clauses)
      clause = ""
      clauses.each do |e|
        clause += e.to_s + " "
      end
      clause += '0'
      @cnf.append clause
      @clause_count += 1
    end

    def add_clauses_with_weight (clauses,weight)
      clause = weight.to_s + " "
      clauses.each do |e|
        clause += e + " "
      end
      clause += '0'
      @cnf.append clause
    end

    def cnf_text
      str = "p cnf #{@variabe_count} #{@clause_count}\n"
      @cnf.each do |e|
        str += e + "\n"
      end
      str
    end

    def wcnf_text
    end
  end
end
