class Aesthetic < ApplicationRecord
    validates :game_id, presence: true, uniqueness: true
    validates :colors, presence: true
    validates :labels, presence: true
    validates :font, presence: true

    belongs_to :game

    validate :validate_colors

    private

    def validate_colors
        return if colors.blank?

        unless colors.is_a?(Array) && colors.all? { |color_hash| valid_hex_color?(color_hash) }
            errors.add(:colors, "must be an array of hex codes (string)")
        end
    end

    def valid_hex_color?(color)
        color.match?(/^#([0-9A-Fa-f]{6})$/)
    end
end
