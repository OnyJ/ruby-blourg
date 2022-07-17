# frozen_string_literal: true

# Ce fichier devra contenir votre système de traduction en langue Blorg.
# Veuillez vous assurer de tirer le meilleur profit de la programmation object
# d'assurer une qualite de production
#
# Il sera exécuté de la façon suivante:
# ruby blorg.rb encode '...'
# ruby blorg.rb decode '...'

require_relative 'characters_table'
INVALID_BLOURG = 'Invalid Blourg format'

module BlorgValidation
  def self.char_exists?(character)
    TRANSLATION_TABLE.key?(character.upcase) || TRANSLATION_TABLE.value?(character)
  end

  def self.say_invalid_blourg
    puts INVALID_BLOURG
    return false
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
      unless char_exists?(letter)
        puts 'Error: One or multiple Blourg letter doesn\'t exist.'
        return false
      end
    end
    true
  end

  def self.blourg_is_valid?(blourg_str)
    blourg_str = blourg_str.downcase
    return say_invalid_blourg unless translatable?(blourg_str)
    return say_invalid_blourg unless blourg_char_valid?(blourg_str)

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

  def self.decode(str)
    str = str.downcase

    return INVALID_BLOURG unless BlorgValidation.blourg_is_valid?(str)

    # code for str_into_french(str) :

    french = ''
    str.split.each do |blourg|
      french += BlorgChar.char_into_french(blourg)
    end

    # code to insert spaces :

    space_positions = []
    words = str.split('  ')
    for i in 0..words.count - 1 do
      spacement = (words[i].length / 4) + i + (1 * i)
      space_positions.push(spacement)
    end

    # spaces exceptions (at start and at the end)
    french.insert(french.length, ' ') if str[str.length - 2] == ' ' && str[str.length - 2] == ' '
    space_positions.pop
    space_positions.each { |i| french.insert(i, ' ') }

    french.downcase
  end
end
