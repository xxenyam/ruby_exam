require 'rspec'
require_relative 'exam'

RSpec.describe RetryExecutor do
  let(:executor) { RetryExecutor.new(max_retries: 3) }

  context "коли блок виконується без помилок" do
    it "повинен виконати блок тільки один раз" do
      expect { 
        executor.execute { puts "Успіх!" }
      }.not_to raise_error
    end
  end

  context "коли блок генерує помилку" do
    it "повторює виконання блоку до 3 разів" do
      attempts = 0
      executor.execute do
        attempts += 1
        raise 'Помилка!' if attempts < 3
      end
      expect(attempts).to eq(3) 
    end

    it "після 3 спроб генерує помилку, якщо не вдалося виконати блок" do
      expect {
        executor.execute do
          raise 'Помилка!'
        end
      }.to raise_error('Помилка!')
    end
  end
end
