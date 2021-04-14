require 'spec_helper'

RSpec.describe Recomendacao do
  describe '.stopwords metodo de classe' do
    subject(:stopwords) { described_class.stopwords }

    specify do
      expect {
        stopwords
      }.not_to raise_error
    end

    specify do
      is_expected.to be_a_kind_of(Hash)
    end

    specify do
      expect(stopwords.keys).to match_array(%w[pt-br en])
    end

    specify do
      expect(stopwords.fetch('pt-br')).to be_a_kind_of(Array)
    end
  end

  describe '.tokenize' do
    context 'com o idioma padrão' do
      specify { expect(described_class.tokenize('01 - o sonho the amor')).to match_array(%w[sonho amor]) }
    end

    context 'com idioma "pt-br" e acentuação' do
      specify { expect(described_class.tokenize('01 - nOmE da música', lang: 'pt-br')).to match_array(%w[nome música]) }
    end

    context 'com idioma "pt-br"' do
      specify { expect(described_class.tokenize('01 - o sonho the amor', lang: 'pt-br')).to match_array(%w[the sonho amor]) }
    end

    context 'com idioma "en"' do
      specify { expect(described_class.tokenize('01 - o sonho the amor', lang: 'en')).to match_array(%w[o sonho amor]) }
    end
  end
end
