module Acropolis
  module AttachmentAccessToken
    private
    # simple random salt
    def random_salt(len = 20)
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      salt = ""
      1.upto(len) { |i| salt << chars[rand(chars.size-1)] }
      return salt
    end

    # SHA1 from random salt and time
    def generate_access_token
      self.attachment_access_token = Digest::SHA1.hexdigest("#{random_salt}#{Time.zone.now.to_i}")
    end

    # interpolate in paperclip
    ::Paperclip.interpolates :attachment_access_token  do |attachment, style|
      attachment.instance.attachment_access_token
    end
  end
end
