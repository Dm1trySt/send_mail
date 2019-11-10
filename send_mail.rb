require 'pony'
require 'io/console'


puts "Введите ваш e-mail:"
my_mail = STDIN.gets.chomp

puts "Введите пароль вашей почты #{my_mail} для отправки письма:"
# .noecho(&:gets) - скрывает вводимую информацию (работает только в консоли)
# используется из gem io/console
password = STDIN.noecho(&:gets).chomp

puts "Кому отправить письмо?"
send_to = STDIN.gets.chomp

puts "Тема письма:"
theme = STDIN.gets.chomp

puts "Что написать в письме?"
body = STDIN.gets.chomp

begin

  # gem Pony для отправки письма
  Pony.mail(
      # Используем хэш-массив
      {
          subject: theme, # тема письма
          body: body, # текст письма, его тело
          to: send_to, # кому отправить письмо
          from: my_mail, # от кого письмо (наш обратный адрес)

          # Ниже идут настройки Pony для почтового ящика на mail.ru. Подробнее об опциях
          # Pony для других сервисов см. документацию:
          # https://github.com/benprew/pony
          via: :smtp,
          via_options: {
              address: 'smtp.mail.ru', # это хост, сервер отправки почты
              port: '465', # порт
              tls: true, # если сервер работает в режиме TLS
              user_name: my_mail, # используем наш адрес почты как логин
              password: password, # задаем введенный в консоли пароль
              authentication: :plain # "обычный" тип авторизации по паролю
          }
      }
  )

  puts "Писмо успешно отправлено"

  # Полсе rescue возможная ошибка соединения с сервером
rescue SocketError
  puts "Не могу соединиться с сервером "

  # Введен ошибочный адрес адресата
rescue Net::SMTPSyntaxError=> error
  # error.messege - вывод сообщения ошибки (eng)
  puts "Вы не корректно задали параметры письма: " + error.message

  # Ошибка ввода пароля
rescue Net::SMTPAuthenticationError => error
  # error.messege - вывод сообщения ошибки (eng)
  puts "Вы не правильно ввели пароль: " + error.message
end

