#include cyllabus infomation
#cyllabus_info = cyllabus parse
#cnf_file = generate cnf file(cyllabus_info)
#output = call sat solver(cnf_file)
#json = decode(output)
#print fullcalendar(json)
