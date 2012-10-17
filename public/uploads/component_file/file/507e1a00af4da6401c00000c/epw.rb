require 'nokogiri'
require 'open-uri'
require 'csv'
require 'fileutils'
require 'net/http'

exit if defined?(Ocra)

URL = "http://www.nusens.com.tw/IPower/wse/CampusWeather.aspx?CP_ID=1"

def getData
  doc = Nokogiri::XML(open(URL))
  data = {}
  %w(WS_Temp WS_Hum WS_Vel WS_VelDir WS_Solar WS_Rain).each{|w|
    data[w] = doc.css("#{w} Value").text
  }
  return data
end

def saveFile data, file_path
  FileUtils::copy(file_path, file_path + ".backup")
  csv = CSV.read(file_path)
  now = Time.now
  year, month, day, hour = now.year.to_s, now.month.to_s, now.day.to_s, now.hour.to_s
  csv.each{|row|
    if row[0] == year && row[1] == month && row[2] == day && row[3]%24 == hour
      puts "Origin: " + row.inspect
      row[6] = data["WS_Temp"]
      row[7] = (data["WS_Temp"].to_f - (100 - data["WS_Hum"].to_f) / 5.0).to_s
      row[8] = data["WS_Hum"]
      row[21] = data["WS_Vel"]
      row[33] = data["WS_Rain"]
      puts "New:    " + row.inspect
    end
  }

  begin
    CSV.open(file_path, "wb"){|csv_file|
      csv.each{|row|
        csv_file << row
      }
    }  
  rescue Errno::EACCES => e
    $stderr.puts e
    $stderr.puts "Can't write '#{file_path}', please close any application that using this file."
  end
end

file_path = ARGV[0]
unless file_path
  print "epw file path: "
  file_path = gets.chomp
end
puts "Target file: #{file_path}"

if File::exists? file_path
  puts "Service starts"
  loop{
    puts "Updating file '#{file_path}'"
    saveFile(getData, file_path)
    puts "File '#{file_path}' updated at #{Time.now}."
    sleep 3600 # 3600 seconds = 1 hour
  }
else
  $stderr.puts "File `#{file_path}` not found."
end