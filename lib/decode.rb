class Decode
  def initialize
  end

  def decode(output,cyllabus)
    model = []
    File.open(output,"r") do |f| #FIXME: .mdlファイルが生成されなかった時の処理
      if f.readline.chop == "UNSAT"
        puts "unsat"#FIXME: エラー処理未実装
        exit
      end
      model = f.readline.chop.split.map{|i| i.to_i}
    end

    model.each do |e|
      if e > 0
        cyllabus.list[(e-1)/TIMETABLESIZE].period = e.to_period#TODO: デコードをjsでするならいらない
        cyllabus.list[(e-1)/TIMETABLESIZE].period_id = (e-1)%TIMETABLESIZE#HACK: 求めたピリオド情報0-時間割コマ数-1
      end
    end

    return cyllabus.to_json
  end

  def decode_csp(output,cyllabus)

  end

  def decode_to_csv(output, cyllabus)
    model = []
    File.open(output,"r") do |f| #FIXME: .mdlファイルが生成されなかった時の処理
      if f.readline.chop == "UNSAT"
        puts "unsat"#FIXME: エラー処理未実装
        exit
      end
      model = f.readline.chop.split.map{|i| i.to_i}
    end

    model.each do |e|
      if e > 0
        cyllabus.list[(e-1)/TIMETABLESIZE].period = e.to_period#TODO: デコードをjsでするならいらない
        cyllabus.list[(e-1)/TIMETABLESIZE].period_id = (e-1)%TIMETABLESIZE#HACK: 求めたピリオド情報0-時間割コマ数-1
      end
    end

    return cyllabus.to_csv
  end
end

class Integer
  def to_period#TODO: デコードをjsでするならいらない
    period = ""
    self%TIMETABLESIZE == 0 ? tmp = TIMETABLESIZE-1 : tmp = self%TIMETABLESIZE-1
    case (tmp%40)/8
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

