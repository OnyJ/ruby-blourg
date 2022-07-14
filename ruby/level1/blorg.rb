# frozen_string_literal: true

# Ce fichier devra contenir votre système de traduction en langue Blorg.
# Veuillez vous assurer de tirer le meilleur profit de la programmation object
# d'assurer une qualite de production
#
# Il sera exécuté de la façon suivante:
# ruby blorg.rb encode '...'
# ruby blorg.rb decode '...'

require_relative 'characters_table'

module BlorgValidation
  def self.char_exists?(character)
    TRANSLATION_TABLE.key?(character.upcase) || TRANSLATION_TABLE.value?(character)
  end

  def self.translatable?(sentence)
    response = sentence.delete(' ').split('').map do |character|
      char_exists?(character)
    end
    !response.include?(false)
  end
end

module BlorgChar
  include BlorgValidation

  def self.char_into_french(blourg_char)
    TRANSLATION_TABLE.select { |_key, value| blourg_char == value }.to_s[2]
  end

  def self.char_into_blourg(french_char)
    equivalent = TRANSLATION_TABLE.select { |key, _value| french_char == key }
    equivalent[french_char]
  end
end

class Blorg
  include BlorgValidation
  include BlorgChar
end
