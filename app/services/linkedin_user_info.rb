class LinkedinUserInfo
  include HTTParty
  base_uri 'https://piloterr.com'

  def initialize(api_key)
    @headers = {
      'Content-Type' => 'application/json',
      'x-api-key' => api_key
    }
  end

  def fetch_user_info(query)
    options = {
      headers: @headers,
      query: { query: query }
    }
    self.class.get('/api/v2/linkedin/profile/info', options)
  end
end 