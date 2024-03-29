$:.unshift(File.join(File.dirname(__FILE__),'..','lib'))

require 'cyllabus'
require 'encode'
require 'solver'
require 'decode'
TIMETABLESIZE = 320
cyllabus = Cyllabus.new
cyllabus.load_from(File.expand_path('../../src/cyllabus.csv',__FILE__))#HACK: Pathnameを使える
cyllabus.subdivide_by_required_time
cyllabus.set_inner_id
cyllabus.generate_continuous_lectures

encoder = Encode.new
solver = Solve.new
decoder = Decode.new

cnf_file_path = encoder.generate_cnf(cyllabus)
output_file_path = solver.call_minisat(cnf_file_path)
json = decoder.decode(output_file_path,cyllabus)#NOTE: fullcalendarで扱えるjson形式で出力

csv = decoder.decode_to_csv(output_file_path, cyllabus)#NOTE: demo

File.open(File.expand_path("../../tmp/output.json",__FILE__),"w") do |f|
  f.write(json)
end

File.open(File.expand_path("../../tmp/output.csv",__FILE__),"w") do |f|
  f.write(csv)
end
