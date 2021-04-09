memo_dates = []

memo_name = 'a'
memo_id = 1234
memo_text = 'hoge'

memo_date = { 'memo_name' => memo_name, 'memo_id' => memo_id, 'memo_text' => memo_text }

memo_dates << memo_date

p memo_dates.find { |memo_date|
  memo_date['memo_id'] == memo_id
}
