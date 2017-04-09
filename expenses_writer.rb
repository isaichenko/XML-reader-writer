# encoding: utf-8
# (с) 2015 goodprogrammer.ru
# Курс "Настоящее программирование для всех 2" (продвинутый блок)

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

puts "На что потратили деньги?"
expense_text = STDIN.gets.chomp

puts "Сколько потратили?"
expense_amount = STDIN.gets.chomp.to_i

puts "Укажите дату траты в формате дд.мм.гггг, например 12.05.2003 (пустое поле - сегодня)"
date_input = STDIN.gets.chomp

expense_date = nil

if date_input == ''
  expense_date = Date.today
else
  expense_date = Date.parse(date_input)
end

puts "В какую категорю занести трату?"
expense_category = STDIN.gets.chomp

current_path = File.dirname(__FILE__)
file_name = current_path + "/my_expenses.xml"

file = File.new(file_name, "r:UTF-8")
doc = REXML::Document.new(file)
file.close

expenses = doc.elements.find('expenses').first

expense = expenses.add_element 'expense', {
                        'date' => expense_date.to_s,
                        'category' => expense_category,
                        'amount' => expense_amount
                              }

expense.text = expense_text

file = File.new(file_name, "w:UTF-8")
doc.write(file, 2)
file.close

puts "Запись успешно сохранена!"
