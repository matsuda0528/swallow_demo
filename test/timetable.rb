require 'json'

result = ""
File.open("output.json","r") do |f|
  result = f.readlines
end
json = JSON.parse(result.first)

#HACK: jsをきれいに
head = <<-EOS
<!DOCTYPE html>
<html lang="ja">
  <head>
    <title>時間割</title>
    <meta charset="utf-8">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js"></script>

    <style>
      table,td,th{
        border: 1px solid #595959;
        border-collapse: collapse;
      }
      td, th {
      	padding: 3px;
	      width: 30px;
	      height: 25px;
	      white-space: nowrap;
        width: auto;
      }
      th {
	      background: #f0e6cc;
      }
      .even {
	      background: #fbf8f0;
      }
      .odd{
        background: #fefcf9;
      }
    </style>

    <script>
      const json = #{JSON.generate(json)}
    </script>

  </head>
EOS

body = ""
4.times do |i|
  body += <<-EOS
<body>
  <h2>TERM #{i+1}</h2>
  <table id="term#{i+1}">
	<tbody>
		<tr>
			<td rowspan="2">曜日</td>
			<td>時限</td>
			<td colspan="3">1 (8:40~9:40)</td>
			<td colspan="3">2 (9:50~10:50)</td>
			<td colspan="3">3 (11:00~12:00)</td>
			<td colspan="3">4 (12:50~13:50)</td>
			<td colspan="3">5 (14:00~15:00)</td>
			<td colspan="3">6 (15:10~16:10)</td>
			<td colspan="3">7 (16:20~17:20)</td>
			<td colspan="3">8 (17:30~18:30)</td>
		</tr>
		<tr>
			<td>学年</td>
			<td>授業科目</td>
			<td>担当教員</td>
			<td>教室</td>
			<td>授業科目</td>
			<td>担当教員</td>
			<td>教室</td>
			<td>授業科目</td>
			<td>担当教員</td>
			<td>教室</td>
			<td>授業科目</td>
			<td>担当教員</td>
			<td>教室</td>
			<td>授業科目</td>
			<td>担当教員</td>
			<td>教室</td>
			<td>授業科目</td>
			<td>担当教員</td>
			<td>教室</td>
			<td>授業科目</td>
			<td>担当教員</td>
			<td>教室</td>
			<td>授業科目</td>
			<td>担当教員</td>
			<td>教室</td>
		</tr>
	</tbody>
</table>

  <script>
  var day_of_week = ['月','火','水','木','金']

  var table = document.getElementById('term#{i+1}');
  for(var i=#{i*20}; i<#{(i+1)*20}; i++){
    var tr = document.createElement('tr');
    for(var j=0; j<25; j++){
      if(i%4==0 && j==0){
        var td_span = document.createElement('td');
        td_span.rowSpan = 4;
        td_span.textContent = day_of_week[(i/4)%5]
        tr.appendChild(td_span);
      }
      var td = document.createElement('td');
      if(j==0){
        td.textContent = i%4+1;
      }else{
        //td.textContent = i*24+j-1;
        for(var lec in json){
          if(json[lec].period_id == Math.floor((i*24+j-1)/3) && (i*24+j-1)%3 == 0){
            td.textContent = json[lec].name;
          }
          if(json[lec].period_id == Math.floor((i*24+j-1)/3) && (i*24+j-1)%3 == 1){
            td.textContent = json[lec].instructors;
          }
        }
      }
      tr.appendChild(td);
    }
    table.appendChild(tr);
  }
  </script>
EOS
end

last = <<-EOS
  </body>
</html>
EOS

File.open("index.html","w") do |f|
  f.write(head + body + last)
end
