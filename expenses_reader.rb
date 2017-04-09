# encoding: utf-8
# XXX/ Этот код необходим только при использовании русских букв на Windows
if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end
# /XXX

require "rexml/document" #подключаем парсер
require "date" # будем использовать операции с данными

current_path = File.dirname(__FILE__)
file_name = current_path + "/my_expenses.xml"

abort "Извиняемся, хозяин, файлик my_expenses.xml не найден." unless File.exist?(file_name)

file = File.new(file_name)

doc = REXML::Document.new(file) # создает новый XML объект из файла file

amount_by_day = Hash.new

doc.elements.each("expenses/expense") do |item| # XPath - формат адресации расположения элементов внутри XML документа
  loss_sum = item.attributes["amount"].to_i
  loss_date = Date.parse(item.attributes["date"])

  amount_by_day[loss_date] ||= 0 #условное присвоение: присвоить выражению значение, если выражение пусто

  amount_by_day[loss_date] += loss_sum
end

file.close

sum_by_month = Hash.new

current_month = amount_by_day.keys.sort[0].strftime("%B %Y")

amount_by_day.keys.sort.each do |key|
  sum_by_month[key.strftime("%B %Y")] ||= 0
  sum_by_month[key.strftime("%B %Y")] += amount_by_day[key]
end

# выводим заголовок для первого месяца
puts "------[ #{current_month}, всего потрачено: #{sum_by_month[current_month]} р. ]---------"

amount_by_day.keys.sort.each do |key|
  if key.strftime("%B %Y") != current_month
    current_month = key.strftime("%B %Y")
    puts "------[ #{current_month}, всего потрачено: #{sum_by_month[current_month]} р. ]---------"
  end

  puts "\t#{key.day}: #{amount_by_day[key]} р."
end

