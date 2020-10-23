$:.unshift(File.join(File.dirname(__FILE__),'..','lib'))

require 'cyllabus'
require 'encode'
require 'solver'
require 'decode'
TIMETABLESIZE = 640
cyllabus = Cyllabus.new
cyllabus.load_from(File.expand_path('../../src/cyllabus.csv',__FILE__))#HACK: Pathnameを使える
cyllabus = cyllabus.subdivide_by_required_time

encoder = Encode.new
solver = Solve.new
decoder = Decode.new
csp_file_path = encoder.generate_csp(cyllabus)
output_file_path = solver.call_sugar(csp_file_path)
json = decoder.decode_csp(output_file_path,cyllabus)
# cnf_file_path = encoder.generate_cnf(new_cyllabus)
#
# output_file_path = solver.call_minisat(cnf_file_path)
# json = decoder.decode(output_file_path,new_cyllabus)#NOTE: fullcalendarで扱えるjson形式で出力

File.open(File.expand_path("../../tmp/output.json",__FILE__),"w") do |f|
  f.write(json)
end
