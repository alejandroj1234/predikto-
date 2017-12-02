require 'open-uri'
module FixerApi
  def call_fixer_api(date, base)
    open("https://api.fixer.io/#{date}?base=#{base}").read
  end
end