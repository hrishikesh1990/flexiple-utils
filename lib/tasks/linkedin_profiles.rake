namespace :linkedin_profiles do
  desc "Process LinkedIn profiles from CSV"
  task :process, [:input_file, :output_file] => :environment do |t, args|
    unless args[:input_file] && args[:output_file]
      puts "Usage: rake linkedin_profiles:process[input.csv,output.csv]"
      exit 1
    end

    api_key = 'd3418c47-6ba4-4d7e-9b79-6c9bb413d83f'
    unless api_key
      puts "PILOTERR_API_KEY environment variable is required"
      exit 1
    end

    processor = LinkedinProfileProcessor.new(api_key)
    processor.process_csv(args[:input_file], args[:output_file])
  end
end 