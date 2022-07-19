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

  def self.char_into_french(blourg_char)
    TRANSLATION_TABLE.select { |_key, value| blourg_char == value }.to_s[2]
  end

  def self.char_into_blourg(french_char)
    TRANSLATION_TABLE.select { |key, _value| french_char == key }.to_s[7..10]
  end
end

class Blorg
  include BlorgValidation
  include BlorgChar

  def self.string_into_french(str)
    french = ''
    str.split.each do |blourg_char|
      french += BlorgChar.char_into_french(blourg_char)
    end
    french
  end

  def self.string_into_blourg(str)
    blourg = ''
    str.split('').each do |french_char|
      blourg += BlorgChar.char_into_blourg(french_char).to_s + ' '
    end
    blourg[0..(blourg.length - 2)]
  end

  def self.get_blourg_space_positions(str)
    space_positions = []
    words = str.split('  ')
    (0..words.count - 1).each do |i|
      spacement = (words[i].length / 4) + i + (1 * i)
      space_positions.push(spacement)
    end
    space_positions
  end

  def self.get_french_space_positions(str)
    # space_positions = []
    # words = str.split('')
    # (0..words.count - 1).each do |i|
    #   # spacement = (words[i]+ i)
    #   space_positions.push(i) if words[i] == ' '
    # end
    # puts space_positions
    # space_positions
  end

  def self.insert_exceptionnal_blourg_space(str, french)
    end_contains_space = str[str.length - 1] == ' ' && str[str.length - 2] == ' '
    french.insert(french.length, ' ') if end_contains_space
    french
  end

  def self.insert_spaces_into_french(str, french_without_spaces)
    french = french_without_spaces
    space_positions = get_blourg_space_positions(str)
    space_positions.pop

    french = insert_exceptionnal_blourg_space(str, french)
    space_positions.each { |pos| french.insert(pos, ' ') }
    french
  end

  def self.insert_spaces_into_blourg(str, blourg_without_double_spaces)
    # puts "okok"
    # blourg = blourg_without_double_spaces
    # space_positions = get_french_space_positions(str)
    # # space_positions.pop

    # space_positions.each { |pos| blourg.insert(pos, ' ')}
    # puts blourg
    # blourg
  end

  def self.decode(str)
    str = str.downcase
    return INVALID_BLOURG unless BlorgValidation.blourg_string_valid?(str)

    french = string_into_french(str)
    french = insert_spaces_into_french(str, french)
    french.downcase
  end

  def self.encode(str)
    str = str.upcase
    return INVALID_FRENCH unless BlorgValidation.translatable?(str)

    blorg = ''

    blorg = string_into_blourg(str)
    # blorg = insert_spaces_into_blourg(str, blorg)
    blorg
  end
end
