# encoding: utf-8

require "rubygems"
require "yaml"

require "bundler/setup"
require "sinatra"

$notes = []

note_dir_names = YAML.load(File.read("directories.yml"))["note_directories"]

unless note_dir_names.is_a? Array
  puts "Something's wrong with your config.yml so I'm quitting."
  exit
end

def load_note(text, mod_date)
  $notes << {:text => text, :mod_date => mod_date}
end

def format_note(note)
  text = note[:text]

  # https://stackoverflow.com/questions/29877310/invalid-byte-sequence-in-utf-8-argumenterror
  unless text.force_encoding("UTF-8").valid_encoding?
    text = text.scrub("&thinsp;&hellip;&thinsp;")
  end

  mod_date = note[:mod_date]

  if text.length > 1000
    formatted_text = text.gsub(/^(.+)$/, '<p class="long">\1</p>')
  else
    formatted_text = text.gsub(/^(.+)$/, '<p>\1</p>')
  end

  formatted_text = formatted_text.gsub(URI.regexp(["http"]), '<a href="\0">\0</a>')

  begin
    formatted_date = mod_date.strftime("%B %Y") # was "%B %d, %Y"
  rescue
    # probably not a proper date string, so we'll just let it through as-is
    # e.g. "From the mists of time"
    formatted_date = mod_date
  end

  "<p class=\"date\">#{formatted_date}</p>" + formatted_text
end

note_dir_names.each do |note_dir_name|
  dir_name_no_trailing_slash = Pathname.new(note_dir_name)
  Dir["#{dir_name_no_trailing_slash}/*.{txt,yml}"].each do |filename|
    if File.extname(File.basename(filename)) == ".txt"
      mod_date = File.mtime(filename)
      load_note(File.read(filename), mod_date)
    elsif File.extname(File.basename(filename)) == ".yml"
      yaml = YAML.load(File.read(filename))
      begin
        yaml.each do |line|
          if line.is_a? String
            load_note(line, "From the mists of time")
          end
        end
      rescue
        puts "Skipping a YAML file that doesn't look quite right: #{filename}"
      end
    else
      puts "Skipping a file that's neither text or YAML: #{filename}"
    end
  end
end

template = File.read("template.html")

get "/" do
  formatted = format_note($notes[rand($notes.length).floor])
  template.gsub("PUT_NOTE_HERE", formatted)
end