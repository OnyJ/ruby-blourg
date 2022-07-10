# frozen_string_literal: true

# Ce fichier devra contenir votre système de traduction en langue Blorg.
# Veuillez vous assurer de tirer le meilleur profit de la programmation object
# d'assurer une qualite de production
#
# Il sera exécuté de la façon suivante:
# ruby blorg.rb encode '...'
# ruby blorg.rb decode '...'

require_relative 'characters_table'

class Blorg
  def self.get_french_character(blourg_char)
    return unless translatable?(blourg_char)

    TRANSLATION_TABLE.select { |_key, value| blourg_char == value }.to_s[2]
  end

  def self.get_blourg_character(blourg_char)
    return unless translatable?(blourg_char)

    equivalent = TRANSLATION_TABLE.select { |key, _value| blourg_char == key }
    equivalent[blourg_char]
  end

  def self.translatable?(character)
    TRANSLATION_TABLE.key?(character) || TRANSLATION_TABLE.value?(character)
  end
end
