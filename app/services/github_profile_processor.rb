require 'csv'

class GithubProfileProcessor
  GITHUB_URL_PATTERN = %r{.*github\.com/([^/]+)}
  
  def initialize(api_key)
    @api_key = api_key
    @github_service = GithubUserInfo.new(api_key)
  end

  def process_csv(input_file_path, output_file_path)
    processed_profiles = []
    
    CSV.foreach(input_file_path, headers: true) do |row|
      profile_url = row['github_url']
      username = extract_username(profile_url)
      
      next unless username
      
      result = process_profile(username)
      processed_profiles << result
    end
    
    save_to_csv(processed_profiles, output_file_path)
  end

  private

  def extract_username(url)
    return nil unless url
    match = GITHUB_URL_PATTERN.match(url)
    match ? match[1] : nil
  end

  def process_profile(username)
    existing_profile = GithubProfile.find_by(username: username)
    return existing_profile if existing_profile&.updated_at&.> 24.hours.ago

    response = @github_service.fetch_user_info("https://github.com/#{username}")
    
    profile_data = {
      username: username,
      status: response.success? ? 'success' : 'failed',
      raw_data: response.success? ? response.parsed_response : { error: response.code }
    }

    save_profile(profile_data)
    profile_data
  end

  def save_profile(data)
    profile = GithubProfile.find_or_initialize_by(username: data[:username])
    profile.update(
      raw_data: data[:raw_data],
      status: data[:status]
    )
  end  

  def save_to_csv(profiles, output_file_path)
    CSV.open(output_file_path, 'w') do |csv|
      csv << ['username', 'status', 'raw_data']
      
      profiles.each do |profile|
        csv << [
          profile[:username],
          profile[:status],
          profile[:raw_data].to_json
        ]
      end
    end
  end
end 