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

puts "Что написать в письме?"
body = STDIN.gets.chomp


# gem Pony для отправки письма
Pony.mail(
        # Используем хэш-массив
        {
            subject: 'Привет из программы на руби!', # тема письма
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