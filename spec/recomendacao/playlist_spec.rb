require 'spec_helper'

RSpec.describe Recomendacao::Playlist do

  describe '.reproduzindo?' do
    subject { described_class.new([]) }

    it { is_expected.not_to be_reproduzindo }
  end

  describe 'controle de estados de reprodução' do
    let(:playlist) { described_class.new([musica1, musica2, musica3, musica4]) }
    let(:musica1) { Recomendacao::Musica.new(titulo: 'musica 1') }
    let(:musica2) { Recomendacao::Musica.new(titulo: 'musica 2') }
    let(:musica3) { Recomendacao::Musica.new(titulo: 'musica 3') }
    let(:musica4) { Recomendacao::Musica.new(titulo: 'musica 4') }
    let(:recomendador) { double }

    it 'deve iniciar sem musica reproduzindo' do
      expect(playlist.reproduzindo?).to eq(false)
      expect(playlist.musica_atual).to eq(nil)
      expect(playlist.musica_anterior).to eq(nil)
      expect(playlist.reproduzidas).to eq([])
    end

    it 'deve selecionar uma musica aleatoria e manter reproduzindo a reprodução quando mudar proxima ou anterior' do
      expect(playlist).to receive(:musica_aleatoria).and_return(musica1)
      expect(playlist.reproduzindo?).to eq(false)

      primeira = playlist.play!
      expect(musica1).to eq(primeira)
      expect(playlist.reproduzindo?).to eq(true)
      expect(primeira).to eq(playlist.musica_atual)
      expect(playlist.musica_anterior).to eq(nil)
      expect(playlist.reproduzidas.size).to eq(1)

      expect(recomendador).to receive(:recomendar).and_return(musica2)
      allow(playlist).to receive(:recomendador).and_return(recomendador)
      segunda = playlist.proxima!
      expect(musica2).to eq(segunda)
      expect(playlist.reproduzindo?).to eq(true)
      expect(playlist.musica_anterior).to eq(primeira)
      expect(playlist.reproduzidas.size).to eq(2)

      playlist.anterior!
      expect(playlist.reproduzindo?).to eq(true)
      expect(playlist.musica_atual).to eq(primeira)
      expect(playlist.musica_anterior).to eq(nil)
      expect(playlist.reproduzidas.size).to eq(1)

      playlist.stop!
      expect(playlist.reproduzindo?).to eq(false)
    end
  end
end
