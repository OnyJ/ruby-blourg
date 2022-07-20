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
INVALID_FRENCH = 'Invalid French format'

module BlorgValidation
  @blourg_length_error = 'Error: Each Blourg letter must be 4 characters long.'
  @blourg_unknown_error = 'Error: One or multiple Blourg letter doesn\'t exist.'

  def self.char_exists?(character)
    TRANSLATION_TABLE.key?(character.upcase) || TRANSLATION_TABLE.value?(character)
  end

  def self.return_error(error)
    puts error
    false
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
      return return_error(@blourg_length_error) unless letter.length == 4
      return return_error(@blourg_unknown_error) unless char_exists?(letter)
    end
    true
  end

  def self.blourg_string_valid?(blourg_str)
    blourg_str = blourg_str.downcase
    return return_error(INVALID_BLOURG) unless translatable?(blourg_str)
    return return_error(INVALID_BLOURG) unless blourg_char_valid?(blourg_str)

    true
  end
end

module BlorgChar
  include BlorgValidation

  def self.into_french(blourg_char)
    return ' ' if blourg_char == ''

    TRANSLATION_TABLE.select { |_key, value| blourg_char == value }.to_s[2]
  end

  def self.char_into_blourg(french_char)
    TRANSLATION_TABLE.select { |key, _value| french_char == key }.to_s[7..10]
  end

  def self.fix_spaces(sentence, end_is_space)
    sentence += ' ' if end_is_space
    sentence = sentence[1...] if sentence[0..1] == '  '
    sentence
  end
end

class Blorg
  include BlorgValidation
  include BlorgChar

  def self.decode(str)
    str = str.downcase
    return INVALID_BLOURG unless BlorgValidation.blourg_string_valid?(str)

    french       = ''
    last         = str.length - 1
    end_is_space = str[last] == ' ' && str[last - 1] == ' '

    str.split(/ /).each { |char| french += BlorgChar.into_french(char) }
    BlorgChar.fix_spaces(french.downcase, end_is_space)
  end

  def self.encode(str)
    str = str.upcase
    return INVALID_FRENCH unless BlorgValidation.translatable?(str)

    blourg = ''
    i = 0
    last = str.length - 1
    end_is_space = str[last] == ' '

    str.split(//).each do |french_char|
      blourg += BlorgChar.char_into_blourg(french_char).to_s + ' '
      blourg += ' ' if french_char == ' '
      i += 1
    end
    blourg += ' ' if end_is_space
    blourg.gsub!('   ', '  ')
    blourg[0..(blourg.length - 2)]
  end
end
