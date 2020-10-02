$:.unshift(File.join(File.dirname(__FILE__),'..','lib'))

require 'cyllabus'
require 'encode'
require 'solver'
require 'decode'
cyllabus = Cyllabus.new("./../src/cyllabus.csv") 
#FIXME: cyllabus.csvのパス指定の方法を可用性のあるコードに変更
#__FILE__を使えば良さそう

encoder = Encode.new
cnf_file_path = encoder.generate_cnf(cyllabus.filter_by_term 1)
solver = Solve.new
output_file_path = solver.call_qmaxsat(cnf_file_path)
decoder = Decode.new
json = decoder.decode(output_file_path)
#NOTE: print fullcalendar(json)
