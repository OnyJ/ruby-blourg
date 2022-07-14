# frozen_string_literal: true

# Ce fichier sera lancé pour tester l'application
# Veillez à tester les situations et erreur inattendues

require_relative 'blorg'

describe '#decode' do
  it 'translates from Blourg to French' do
    expect(Blorg.decode('rgbh brug bgou obglobglobgl')).to eq 'a b c ...'
    expect(Blorg.decode('uhob rgob uhob rgob olgr hrbo 44')).to eq 't o t o d u 44'
  end
  it 'rejects invalid Blourg sentences' do
    expect(Blorg.decode('ok rgob')).to eq 'Invalid Blourg format'
    expect(Blorg.decode('ab cde')).to eq 'Invalid Blourg format'
    expect(Blorg.decode('a')).to eq 'Invalid Blourg format'
  end
end

describe '#char_into_french' do
  it 'returns the French character matching the given Blourg character' do
    expect(BlorgChar.char_into_french('rlgo')).to eq 'G'
    expect(BlorgChar.char_into_french('glhu')).to eq 'N'
    expect(BlorgChar.char_into_french('hrbo')).to eq 'U'
    expect(BlorgChar.char_into_french('rblg')).to eq '!'
  end
end

describe '#char_into_blourg' do
  it 'returns the Blourg character matching the given French character' do
    expect(BlorgChar.char_into_blourg('V')).to eq 'rgub'
    expect(BlorgChar.char_into_blourg('Q')).to eq 'lrob'
    expect(BlorgChar.char_into_blourg('D')).to eq 'olgr'
    expect(BlorgChar.char_into_blourg('?')).to eq 'grlh'
  end
end

describe '#translatable?' do
  context 'french character verification' do
    it 'returns true if the TRANSLATION_TABLE contains the key' do
      expect(BlorgValidation.translatable?('J')).to be true
      expect(BlorgValidation.translatable?('Z')).to be true
      expect(BlorgValidation.translatable?('E')).to be true
    end
    it "returns false if the TRANSLATION_TABLE doesn't contain the key" do
      expect(BlorgValidation.translatable?(')')).to be false
      expect(BlorgValidation.translatable?('#')).to be false
      expect(BlorgValidation.translatable?('3')).to be false
      expect(BlorgValidation.translatable?(' ')).to be false
    end
  end
end

describe '#translatable?' do
  context 'blourg character verification' do
    it 'returns true if the TRANSLATION_TABLE contains the value' do
      expect(BlorgValidation.translatable?('olgr')).to be true
      expect(BlorgValidation.translatable?('rhol')).to be true
      expect(BlorgValidation.translatable?('uhog')).to be true
    end
    it "returns false if the TRANSLATION_TABLE doesn't contain the value" do
      expect(BlorgValidation.translatable?(' ')).to be false
      expect(BlorgValidation.translatable?('xxxx')).to be false
      expect(BlorgValidation.translatable?('po')).to be false
      expect(BlorgValidation.translatable?('12-c')).to be false
      expect(BlorgValidation.translatable?('1234')).to be false
    end
  end
end

describe '#blourg_is_valid?' do
  it 'returns true if Blourg string is valid' do
    expect(BlorgValidation.blourg_is_valid?('rgob rhol')).to be true
    expect(BlorgValidation.blourg_is_valid?('  rhol ')).to be true
  end
  it 'returns false if Blourg string is not valid' do
    expect(BlorgValidation.blourg_is_valid?('ok rgob')).to be false
    expect(BlorgValidation.blourg_is_valid?('ab cde')).to be false
    expect(BlorgValidation.blourg_is_valid?('a')).to be false
    expect(BlorgValidation.blourg_is_valid?('rgubrgub')).to be false
  end
end
