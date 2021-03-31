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
swallowの入力ファイルの記述方法を示す．
```
initialization do
  nr_terms 1年間の学期数
  nr_periods 1日の時限数
end

periods do
  first start_time: "1時限目の開始時刻", end_time:"1時限目の終了時刻"
  second start_time: "2時限目の開始時刻", end_time:"2時限目の終了時刻"
  ...
end

holiday do
  holiday "休校日"
end

room "教室名" do
  unavailable start_time: "利用不可時間の開始時刻", end_time: "利用不可時間の終了時刻"
  unavailable all_day: "利用不可日（終日）"
end

instructor "教員名" do
  unavailable start_time: "利用不可時間の開始時刻", end_time: "利用不可時間の終了時刻"
  unavailable all_day: "利用不可日（終日）"
end

lecture "授業名" do
  room (開催可能教室名)
  instructor (担当可能教員名)
  time #検討中
end

一般制約名 do
  lecture (授業名)
end
```

一般制約(チェックがついているものが実装済み)
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

