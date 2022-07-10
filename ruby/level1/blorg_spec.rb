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

    describe '#is_translatable?' do
      context 'french character matching' do
        it 'returns true if the TRANSLATION_TABLE contains the key' do
          expect(Blorg.is_translatable?('J')).to be true
          expect(Blorg.is_translatable?('Z')).to be true
          expect(Blorg.is_translatable?('E')).to be true
        end
        it "returns false if the TRANSLATION_TABLE doesn't contain the key" do
          expect(Blorg.is_translatable?(')')).to be false
          expect(Blorg.is_translatable?('#')).to be false
          expect(Blorg.is_translatable?('3')).to be false
          expect(Blorg.is_translatable?(' ')).to be false
        end
      end
      context 'blourg character matching' do
        it 'returns true if the TRANSLATION_TABLE contains the value' do
          expect(Blorg.is_translatable?('olgr')).to be true
          expect(Blorg.is_translatable?('rhol')).to be true
          expect(Blorg.is_translatable?('uhog')).to be true
        end
        it "returns false if the TRANSLATION_TABLE doesn't contain the value" do
          expect(Blorg.is_translatable?(' ')).to be false
          expect(Blorg.is_translatable?('xxxx')).to be false
          expect(Blorg.is_translatable?('po')).to be false
          expect(Blorg.is_translatable?('12-c')).to be false
          expect(Blorg.is_translatable?('1234')).to be false
        end
      end
    end
  end
end
