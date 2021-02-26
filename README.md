# swallow
SATソルバを用いた時間割作成ツール

## 環境

```
$ ruby --version
ruby 2.5.5p157 (2019-03-15 revision 67260) [x86_64-linux]
```

## 使用方法
時間割作成

```
$ swallow.sh run
```

時間割表示

```
$ swallow.sh show
```

## DSLの記述

```
time do
  nr_grades 学年数
  nr_terms 1学年の学期数
  nr_days 1週間の授業日数
  nr_periods 1日の時限数
end

room "教室名" do
  time (学年,学期,曜日,時限)
end

instructor "教員名" do
  time (学年,学期,曜日,時限)
end

lecture "授業名" do
  time (学年,学期,曜日,時限)
  room (教室名)
  instructor (教員名)
end

一般制約名 do
  lecture (授業名)
end
```

一般制約
- [ ] same_start
- [ ] same_time
- [ ] different_time
- [ ] same_days
- [ ] different_days
- [ ] same_weeks
- [ ] different_weeks
- [ ] same_room
- [ ] different_room
- [ ] overlap
- [ ] not_overlap
- [ ] precedence
- [ ] work_day
- [ ] min_gap
- [ ] max_days
- [ ] max_day_load
- [ ] max_breaks
- [ ] max_blocks

