require 'csv'

task "rollbar_analysis": :environment do
  occurrences = JSON.parse(File.read("229_occurrences.json"))["result"]["instances"]

  csv_string = CSV.generate do |csv|
    csv << ["timestamp", "last_seen_at", "time_since_last_seen", "method", "url", "valid", "User-Agent"]
    occurrences.each { |occurrence| csv << Checker.new.check(occurrence) }
  end
  puts csv_string
end

class Checker
  def check(occurrence)
    data = occurrence["data"]
    @request = data["request"]

    timestamp = Time.at(data["timestamp"])
    last_seen_at_iso = @request["session"]["last_seen_at"]
    last_seen_at = DateTime.parse(last_seen_at_iso) if last_seen_at_iso
    time_since_last_seen = timestamp - last_seen_at if last_seen_at

    valid = valid_authenticity_token?(@request["session"], @request["POST"]["authenticity_token"])

    [timestamp, last_seen_at, time_since_last_seen, @request["method"], @request["url"], valid, @request["headers"]["User-Agent"]]
  end

  # All the below code is nicked from rails/actionpack/lib/action_controller/metal/request_forgery_protection.rb

  AUTHENTICITY_TOKEN_LENGTH = 32

  # Checks the client's masked token to see if it matches the
  # session token. Essentially the inverse of
  # +masked_authenticity_token+.
  def valid_authenticity_token?(session, encoded_masked_token) # :doc:
    if encoded_masked_token.nil? || encoded_masked_token.empty? || !encoded_masked_token.is_a?(String)
      return false
    end

    begin
      masked_token = Base64.strict_decode64(encoded_masked_token)
    rescue ArgumentError # encoded_masked_token is invalid Base64
      return false
    end

    # See if it's actually a masked token or not. In order to
    # deploy this code, we should be able to handle any unmasked
    # tokens that we've issued without error.

    if masked_token.length == AUTHENTICITY_TOKEN_LENGTH
      # This is actually an unmasked token. This is expected if
      # you have just upgraded to masked tokens, but should stop
      # happening shortly after installing this gem.
      compare_with_real_token masked_token, session

      raise 'received unmasked token'
    elsif masked_token.length == AUTHENTICITY_TOKEN_LENGTH * 2
      csrf_token = unmask_token(masked_token)

      compare_with_real_token(csrf_token, session) ||
        valid_per_form_csrf_token?(csrf_token, session)
    else
      raise 'token is malformed'
      false # Token is malformed.
    end
  end

  def unmask_token(masked_token) # :doc:
    # Split the token into the one-time pad and the encrypted
    # value and decrypt it.
    one_time_pad = masked_token[0...AUTHENTICITY_TOKEN_LENGTH]
    encrypted_csrf_token = masked_token[AUTHENTICITY_TOKEN_LENGTH..-1]
    xor_byte_strings(one_time_pad, encrypted_csrf_token)
  end

  def compare_with_real_token(token, session) # :doc:
    ActiveSupport::SecurityUtils.fixed_length_secure_compare(token, real_csrf_token(session))
  end

  def valid_per_form_csrf_token?(token, session) # :doc:
    #if per_form_csrf_tokens
      correct_token = per_form_csrf_token(
        session,
        normalize_action_path(@request["url"]),
        @request["method"]
      )

      ActiveSupport::SecurityUtils.fixed_length_secure_compare(token, correct_token)
    #else
      #false
    #end
  end

  def real_csrf_token(session) # :doc:
    session["_csrf_token"] ||= SecureRandom.base64(AUTHENTICITY_TOKEN_LENGTH)
    Base64.strict_decode64(session["_csrf_token"])
  end

  def per_form_csrf_token(session, action_path, method) # :doc:
    OpenSSL::HMAC.digest(
      OpenSSL::Digest::SHA256.new,
      real_csrf_token(session),
      [action_path, method.downcase].join("#")
    )
  end

  def xor_byte_strings(s1, s2) # :doc:
    s2 = s2.dup
    size = s1.bytesize
    i = 0
    while i < size
      s2.setbyte(i, s1.getbyte(i) ^ s2.getbyte(i))
      i += 1
    end
    s2
  end

  def normalize_action_path(action_path) # :doc:
    uri = URI.parse(action_path)
    uri.path.chomp("/")
  end
end

