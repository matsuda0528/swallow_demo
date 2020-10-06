class Decode
  def initialize
  end

  def decode(output,cyllabus)
    model = []
    File.open(output,"r") do |f|
      if f.readline.chop == "UNSAT"
        puts "unsat"#FIXME: エラー処理
      end
      model = f.readline.chop.split.map{|i| i.to_i}
    end

    model.each do |e|
      if e > 0
        cyllabus.text[(e-1)/40].period = e.to_period
      end
    end

    return cyllabus#NOTE: return json object
  end
end

class Integer
  def to_period
    period = ""
    self%40 == 0 ? tmp = 40-1 : tmp = self%40-1
    case tmp/8
    when 0
      period += "月"
    when 1
      period += "火"
    when 2
      period += "水"
    when 3
      period += "木"
    when 4
      period += "金"
    end

    case tmp%8
    when 0
      period += "1"
    when 1
      period += "2"
    when 2
      period += "3"
    when 3
      period += "4"
    when 4
      period += "5"
    when 5
      period += "6"
    when 6 
      period += "7"
    when 7
      period += "8"
    end
    period
  end
end

