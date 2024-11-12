# This model holds the aesthetic modifications for each game.
# It allows for customization of select colors, and font.
#
# @attr [Integer] game_id The foreign key that references the associated `Game` model. (eg. 1)
# @attr [Array<String>] colors An array of hex color values stored as strings. (eg. "#000000")
# @attr [Array<String>] labels An array of label names to match colors. (eg. "Background color")
# @attr [String] font The font style used for text within the game. (eg. "Arial")
#
# @raise [ValidationError] if colors is not an array of valid hex colors
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
