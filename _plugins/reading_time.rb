
module Jekyll
  module ReadingTimeFilter
    # {{ page.content | reading_time }}
    def reading_time(input, wpm=120)
      number_of_words = input.split.length
      if number_of_words < 200
        "1 Minute Read"
      else
        "#{(number_of_words / wpm)} Minute Read"
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::ReadingTimeFilter)
