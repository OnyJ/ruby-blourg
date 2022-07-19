# frozen_string_literal: true

# Ce fichier sera lancé pour tester l'application
# Veillez à tester les situations et erreur inattendues

require_relative 'blorg'

describe '#encode' do
  it 'translates from French to Blourg' do
    expect(Blorg.encode('a b c ...')).to eq 'rgbh  brug  bgou  obgl obgl obgl'
    expect(Blorg.encode('toto mange')).to eq 'uhob rgob uhob rgob  uhog rgbh glhu rlgo lorh'
    expect(Blorg.encode(' tot ')).to eq '  uhob rgob uhob  '
  end
  it 'rejects invalid French sentences' do
    expect(Blorg.encode('###')).to eq 'Invalid French format'
    expect(Blorg.encode('où ça')).to eq 'Invalid French format'
    expect(Blorg.encode('1234')).to eq 'Invalid French format'
  end
end

describe '#decode' do
  it 'translates from Blourg to French' do
    expect(Blorg.decode('rgbh  brug  bgou  obgl obgl obgl')).to eq 'a b c ...'
    expect(Blorg.decode('uhob rgob uhob rgob  uhog rgbh glhu rlgo lorh')).to eq 'toto mange'
    expect(Blorg.decode('  uhob rgob uhob  ')).to eq ' tot '
  end
  it 'rejects invalid Blourg sentences' do
    expect(Blorg.decode('ok rgob')).to eq 'Invalid Blourg format'
    expect(Blorg.decode('ab cde')).to eq 'Invalid Blourg format'
    expect(Blorg.decode('a')).to eq 'Invalid Blourg format'
  end
end

describe '#string_into_french' do
  it 'translates blourg characters into french characters' do
    expect(Blorg.string_into_french('uhob rgob uhob rgob  uhog rgbh glhu rlgo lorh')).to eq 'TOTOMANGE'
    expect(Blorg.string_into_french('rgbh  brug  bgou  obgl obgl obgl')).to eq 'ABC...'
  end
end

describe '#string_into_blourg' do
  it 'translates french characters into blourg characters' do
    expect(Blorg.string_into_blourg('TOTO MANGE')).to eq 'uhob rgob uhob rgob  uhog rgbh glhu rlgo lorh'
    expect(Blorg.string_into_blourg('A B C ...')).to eq 'rgbh  brug  bgou  obgl obgl obgl'
  end
end

describe '#insert_exceptionnal_blourg_space' do
  it 'appends a space to french string if blourg string ends with 2 spaces' do
    expect(Blorg.insert_exceptionnal_blourg_space('ghob ghob  ', 'ii'.dup)).to eq 'ii '
    expect(Blorg.insert_exceptionnal_blourg_space('burh burh ', 'hh'.dup)).to eq 'hh'
  end
end

describe '#insert_spaces_into_french' do
  it 'inserts the right spaces inside the french string' do
    expect(Blorg.insert_spaces_into_french('rgbh  brug  bgou  obgl obgl obgl', 'ABC...'.dup)).to eq 'A B C ...'
    expect(Blorg.insert_spaces_into_french('uhob rgob uhob rgob  uhog rgbh glhu rlgo lorh', 'TOTOMANGE'.dup)).to eq 'TOTO MANGE'
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

describe '#char_exists?' do
  context 'french character verification' do
    it 'returns true if the TRANSLATION_TABLE contains the key' do
      expect(BlorgValidation.char_exists?('J')).to be true
      expect(BlorgValidation.char_exists?('Z')).to be true
      expect(BlorgValidation.char_exists?('E')).to be true
    end
    it "returns false if the TRANSLATION_TABLE doesn't contain the key" do
      expect(BlorgValidation.char_exists?(')')).to be false
      expect(BlorgValidation.char_exists?('#')).to be false
      expect(BlorgValidation.char_exists?('3')).to be false
      expect(BlorgValidation.char_exists?(' ')).to be false
    end
  end
end

describe '#char_exists?' do
  context 'blourg character verification' do
    it 'returns true if the TRANSLATION_TABLE contains the value' do
      expect(BlorgValidation.char_exists?('olgr')).to be true
      expect(BlorgValidation.char_exists?('rhol')).to be true
      expect(BlorgValidation.char_exists?('uhog')).to be true
    end
    it "returns false if the TRANSLATION_TABLE doesn't contain the value" do
      expect(BlorgValidation.char_exists?(' ')).to be false
      expect(BlorgValidation.char_exists?('xxxx')).to be false
      expect(BlorgValidation.char_exists?('po')).to be false
      expect(BlorgValidation.char_exists?('12-c')).to be false
      expect(BlorgValidation.char_exists?('1234')).to be false
    end
  end
end

describe '#translatable?' do
  it 'returns true if the sentence contains only TRANSLATION_TABLE characters' do
    expect(BlorgValidation.translatable?('olgr rhol  ')).to be true
    expect(BlorgValidation.translatable?('  abcde')).to be true
  end
  it 'returns false if the sentence contains only TRANSLATION_TABLE characters' do
    expect(BlorgValidation.translatable?('olgr rhol#{!')).to be false
    expect(BlorgValidation.translatable?('ça')).to be false
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

describe '#blourg_char_valid?' do
  it 'returns true if Blourg string is valid' do
    expect(BlorgValidation.blourg_char_valid?('rgob rhol')).to be true
    expect(BlorgValidation.blourg_char_valid?('  rhol ')).to be true
  end
  it 'returns false if Blourg string is not valid' do
    expect(BlorgValidation.blourg_char_valid?('ok rgob')).to be false
    expect(BlorgValidation.blourg_char_valid?('ab cde')).to be false
    expect(BlorgValidation.blourg_char_valid?('a')).to be false
    expect(BlorgValidation.blourg_char_valid?('rgubrgub')).to be false
  end
end
