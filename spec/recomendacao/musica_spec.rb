require 'spec_helper'

RSpec.describe Recomendacao::Musica do
  subject(:musica) { described_class.new }

  specify do
    expect(musica.id).to eq(nil)
    musica.id = 1
    expect(musica.id).to eq(1)
  end

  specify do
    expect(musica.titulo).to eq(nil)
    musica.titulo = 'Título da musica'
    expect(musica.titulo).to eq('Título da musica')
  end

  specify do
    expect(musica.keywords).to eq([])
    musica.keywords = ['um', 'dois']
    expect(musica.keywords).to eq(['um', 'dois'])
    musica.keywords = 'um'
    expect(musica.keywords).to eq(['um'])
  end

  specify do
    musica.filename = '/tmp/missing.mp3'
    expect(musica).not_to be_mp3
    musica.filename = mp3_file('30sec.mp3')
    expect(musica).to be_mp3
  end

  describe '.mp3_info' do
    subject { musica.send(:mp3_info).keys }

    context 'without file' do
      let(:musica) { described_class.new }

      specify do
        is_expected.to match_array([])
      end
    end

    context 'with file' do
      let(:musica) { described_class.new(filename: mp3_file('30sec.mp3')) }

      specify do
        is_expected.to match_array(%i[album artista genero titulo ano])
      end
    end
  end

  describe '.nome' do
    context 'com arquivo' do
      subject { described_class.new(filename: mp3_file('30sec.mp3')).nome }

      it { is_expected.to eq('Silent MP3 30 Seconds') }
    end

    context 'com título da musica' do
      subject { described_class.new(titulo: 'titulo').nome }

      it { is_expected.to eq('titulo')}
    end
  end
end
