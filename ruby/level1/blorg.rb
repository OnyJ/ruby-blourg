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
    response = sentence.delete(' ').chars.map do |character|
      char_exists?(character)
    end
    !response.include?(false)
  end

  def self.blourg_char_valid?(blourg_str)
    letters = blourg_str.split
    letters.each do |letter|
      if letter.length != 4
        puts 'Error: Each Blourg letter must be 4 characters long.'
        return false
      end
      if !char_exists?(letter)
        puts 'Error: One or multiple Blourg letter doesn\'t exist.'
        return false
      end
    end
    true
  end

  def self.blourg_is_valid?(blourg_str)
    blourg_str = blourg_str.downcase
    return false unless translatable?(blourg_str)
    return false unless blourg_char_valid?(blourg_str)

    true
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
