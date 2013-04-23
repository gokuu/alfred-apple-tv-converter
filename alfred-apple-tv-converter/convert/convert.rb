require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))

message = ''
status = read_status

begin
  Dir.chdir cache_dir

  check_prerequisites

  if status[:in_progress]
    puts "Conversion in progress..."
  else
    process = Proc.new do
      begin
        ffmpeg_location = `which ffmpeg`.strip

        FFMPEG.ffmpeg_binary = ffmpeg_location.empty? ? "/usr/local/bin/ffmpeg" : ffmpeg_location

        AppleTvConverter::CommandLine.new *ARGV

        "Conversion complete!"
      rescue
        "An error occured while converting"
      end
    end

    status = { :in_progress => true }
    write_status status

    # File.open(File.join(cache_dir, 'debug.txt'), 'w') { |f| f.write 'x' }

    message = with_captured_output(process) do |data|
      status = read_status

      raise Interrupt if status[:cancel] == true

      if data
        if data =~ /processing file (\d+) of (\d+):\s*(.*)\s\]/i
          status[:current_file] = $1
          status[:total_files] = $2
          status[:filename] = $3
        elsif data =~ /^\* transcoding/i
          status[:step] = :transcoding
        elsif data =~ /^\* extracting subtitles/i
          status[:step] = :extract_subtitles
        elsif data.gsub(/\r|\n/, ' ') =~ /progress:\s*(\d+(?:\.\d+)?\%)\s* \((\d+:\d+)?\)/i
          status[:progress] = $1
          status[:elapsed] = $2
        else
          # File.open('./debug.txt', 'a+') { |f| f.write "-#{data.gsub(/\r|\n/, ' ')}-\n"}
        end

        # File.open(File.join(cache_dir, 'debug.txt'), 'a+') { |f| f.write "-#{data.gsub(/\r|\n/, ' ')}-\n"}

        write_status status
      end
    end

    status[:in_progress] = false
    write_status status

    puts message
  end
rescue Interrupt
  puts "Conversion process canceled"
rescue => e
  puts e.message + "\n" + e.backtrace.join("\n")
ensure
  cleanup
end