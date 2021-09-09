# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint           not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ShortenedUrl < ApplicationRecord
    validates :long_url, presence: true
    validates :short_url, presence: true, uniqueness:true
    validates :user_id, presence: true


    def self.random_code
        shortened = SecureRandom.urlsafe_base64
        while ShortenedUrl.exists?(short_url: shortened)
            shortened = SecureRandom.urlsafe_base64
        end
        shortened
    end

    def self.create!(user, long_url)
        ShortenedUrl.new(user_id: user.id, long_url: long_url, short_url: ShortenedUrl.random_code)
    end

    belongs_to :submitter,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :User
end
