class Solve
  def initialize
  end

  def call_qmaxsat(cnf_file_path)
    #NOTE: return output file path
  end

  def call_minisat(cnf_file_path)
    output_file_path = "output.mdl"#FIXME: tmpに出力する
    system("minisat #{cnf_file_path} #{output_file_path}")
    return output_file_path
  end
end
