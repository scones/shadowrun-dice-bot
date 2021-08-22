
class Dice

  20.times do |i|
    define_method("roll_#{i + 1}") do |count = 1|
      count.times.map do |j|
        SecureRandom.random_number(i + 1) + 1
      end
    end
  end

end
