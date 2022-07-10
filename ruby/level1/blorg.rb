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
  def self.get_french_character(blorg_char)
    if is_translatable?(blorg_char)
      TRANSLATION_TABLE.select { |_key, value| blorg_char == value }.to_s[2]
    end
  end

  private

  def self.is_translatable?(character)
    TRANSLATION_TABLE.has_key?(character) || TRANSLATION_TABLE.has_value?(character)
  end
end
