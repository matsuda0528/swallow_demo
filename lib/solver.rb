class Solve
  def initialize
  end

  def call_qmaxsat(wcnf_file_path)
    #NOTE: return output file path
  end

  def call_tt_open_wbo_inc(wcnf_file_path)
    output = File.expand_path("../../tmp/output.wcnf",__FILE__)
    system("tt-open-wbo-inc #{wcnf_file_path} > #{output_file_path}")
    return output_file_path
  end

  def call_minisat(cnf_file_path)
    output_file_path = File.expand_path("../../tmp/output.mdl",__FILE__)
    system("minisat #{cnf_file_path} #{output_file_path}")
    return output_file_path
  end

  def call_sugar(csp_file_path)
    output_file_path = File.expand_path("../../tmp/output.mdl",__FILE__)
    system("sugar #{csp_file_path} #{output_file_path}")
    return output_file_path
  end
end
