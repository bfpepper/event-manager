require "csv"
require 'sunlight/congress'
require "pry"

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"


def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zipcode)
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)

  legislator_names = legislators.collect do |legislator|
    "#{legislator.first_name} #{legislator.last_name}"
  end

  legislator_names.join(", ")
end

def clean_phone_numbers(phone_number)
  if phone_number.gsub(/\D/, "").match(/^1?(\d{3})(\d{3})(\d{4})/)
     [$1, $2, $3].join("-")
   end
end

puts "EventManager initialized."

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

contents.each do |row|
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislator = legislators_by_zipcode(zipcode)  ##{legislator}

  phone_number = clean_phone_numbers(row[:homephone])


  puts "#{name} #{zipcode} #{phone_number}"
end
