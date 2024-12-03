class RetryExecutor
  def initialize(max_retries: 3)
    @max_retries = max_retries
  end

  def execute
    attempts = 0

    begin
      attempts += 1
      puts "Спроба ##{attempts}"
      yield
    rescue StandardError => e
      if attempts < @max_retries
        puts "Сталася помилка: #{e.message}. Повторна спроба... (Спроба ##{attempts})"
        retry
      else
        puts "Максимальна кількість спроб досягнута. Помилка: #{e.message}"
        raise e
      end
    end
  end
end

executor = RetryExecutor.new(max_retries: 3)

begin
  executor.execute do
    raise 'Щось пішло не так' if rand > 0.3
    puts "Успіх!"
  end
rescue => e
  puts "Операція не вдалася після кількох спроб. Помилка: #{e.message}"
end
