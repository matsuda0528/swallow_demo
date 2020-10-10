require 'json'

result = ""
File.open("output.json","r") do |f|
  result = f.readlines
end
json = JSON.parse(result.first)

#HACK: jsをきれいに
str = <<-EOS
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

  </head>

  <body>
  <h2>TERM 1</h2>
  <table id="term1">
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

<h2>TERM 2</h2>
<table id="term2">
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

 
<h2>TERM 3</h2>
<table id="term3">
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


<h2>TERM 4</h2>
<table id="term4">
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
  const json = #{JSON.generate(json)}
  var day_of_week = ['月','火','水','木','金']

  var table = document.getElementById('term1');
  for(var i=0; i<20; i++){
    var tr = document.createElement('tr');
    for(var j=0; j<25; j++){
      if(i%4==0 && j==0){
        var td_span = document.createElement('td');
        td_span.rowSpan = 4;
        td_span.textContent = day_of_week[i/4]
        tr.appendChild(td_span);
      }
      var td = document.createElement('td');
      if(j==0){
        td.textContent = i%4+1;
      }else{
        td.textContent = i*24+j-1;
        for(var lec in json){
          if(json[lec].period_id == (i*24+j-1)/3){
            td.textContent = json[lec].name
          }
        }
      }
      tr.appendChild(td);
    }
    table.appendChild(tr);
  }


  var table = document.getElementById('term2');
  for(var i=20; i<40; i++){
    var tr = document.createElement('tr');
    for(var j=0; j<25; j++){
      if(i%4==0 && j==0){
        var td_span = document.createElement('td');
        td_span.rowSpan = 4;
        td_span.textContent = day_of_week[i/4]
        tr.appendChild(td_span);
      }
      var td = document.createElement('td');
      if(j==0){
        td.textContent = i%4+1;
      }else{
        td.textContent = i*24+j-1;
        for(var lec in json){
          if(json[lec].period_id == (i*24+j-1)/3){
            td.textContent = json[lec].name
          }
        }
      }
      tr.appendChild(td);
    }
    table.appendChild(tr);
  }



  var table = document.getElementById('term3');
  for(var i=40; i<60; i++){
    var tr = document.createElement('tr');
    for(var j=0; j<25; j++){
      if(i%4==0 && j==0){
        var td_span = document.createElement('td');
        td_span.rowSpan = 4;
        td_span.textContent = day_of_week[i/4]
        tr.appendChild(td_span);
      }
      var td = document.createElement('td');
      if(j==0){
        td.textContent = i%4+1;
      }else{
        td.textContent = i*24+j-1;
        for(var lec in json){
          if(json[lec].period_id == (i*24+j-1)/3){
            td.textContent = json[lec].name
          }
        }
      }
      tr.appendChild(td);
    }
    table.appendChild(tr);
  }



  var table = document.getElementById('term4');
  for(var i=60; i<80; i++){
    var tr = document.createElement('tr');
    for(var j=0; j<25; j++){
      if(i%4==0 && j==0){
        var td_span = document.createElement('td');
        td_span.rowSpan = 4;
        td_span.textContent = day_of_week[i/4]
        tr.appendChild(td_span);
      }
      var td = document.createElement('td');
      if(j==0){
        td.textContent = i%4+1;
      }else{
        td.textContent = i*24+j-1;
        for(var lec in json){
          if(json[lec].period_id == (i*24+j-1)/3){
            td.textContent = json[lec].name
          }
        }
      }
      tr.appendChild(td);
    }
    table.appendChild(tr);
  }
  </script>

  </body>
</html>
EOS
File.open("index.html","w") do |f|
  f.write(str)
end
