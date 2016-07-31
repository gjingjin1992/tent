module SearchesHelper

  def guests_for_select
    (1..10).map do |n|
      if n == 1
        name = "1 Guest"
      else
        name = "#{n} Guests"
      end
      [name, n]
    end
  end
end
