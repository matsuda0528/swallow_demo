$:.unshift(File.join(File.dirname(__FILE__),'..','lib'))

require 'cyllabus'
require 'encode'
require 'solver'
require 'decode'
cyllabus = Cyllabus.new
cyllabus.load_from("./../src/cyllabus.csv") #FIXME: cyllabus.csvのパス指定の方法を可用性のあるコードに変更
#__FILE__を使えば良さそう
clbs1 = cyllabus.filter_by_term(1)

encoder = Encode.new
solver = Solve.new
decoder = Decode.new
cnf_file_path = encoder.generate_cnf(clbs1)#NOTE: ファイルパスでなくファイルオブジェクトを使う
output_file_path = solver.call_minisat(cnf_file_path)#NOTE: ファイルパスでなくファイルオブジェクトを使う
json = decoder.decode(output_file_path,clbs1)#NOTE: fullcalendarで扱えるjson形式で出力

File.open("output.json","w") do |f|
  f.write(json)
end
