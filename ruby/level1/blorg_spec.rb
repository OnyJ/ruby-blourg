# frozen_string_literal: true

# Ce fichier sera lancé pour tester l'application
# Veillez à tester les situations et erreur inattendues

require_relative 'blorg'

describe Blorg do
  context 'character translation' do
    describe '#get_french_character' do
      it 'returns the French character matching the given Blourg character' do
        expect(Blorg.get_french_character('rlgo')).to eq 'G'
        expect(Blorg.get_french_character('glhu')).to eq 'N'
        expect(Blorg.get_french_character('hrbo')).to eq 'U'
        expect(Blorg.get_french_character('rblg')).to eq '!'
      end
    end
  end
end
