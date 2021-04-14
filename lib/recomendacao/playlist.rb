# frozen_string_literal: true

module Recomendacao
  class Playlist
    attr_reader :reproduzidas
    attr_reader :musicas

    def initialize(musicas)
      @musicas = [musicas].flatten.compact
      @reproduzidas = []
      @reproduzindo = false
    end

    def procurar_musica_por_id(id)
      @musicas.find { |m| m.id == id }
    end

    def reproduzindo?
      @reproduzindo == true
    end

    def stop!
      @reproduzindo = false
      nil
    end

    def play!(musica = nil)
      proxima!(musica).tap do |m|
        @reproduzindo = m.is_a?(Musica)
      end
    end

    def anterior!
      lista = reproduzidas.pop(2)
      return unless lista.size == 2

      def_musica(lista[0])
    end

    def proxima!(musica = nil)
      return def_musica(musica) if musica

      def_musica(
        musica_atual ? recomendador.recomendar : musica_aleatoria
      )
    end

    def musica_anterior
      lista = reproduzidas.last(2)
      lista.size == 2 ? lista.first : nil
    end

    def musica_atual
      reproduzidas.last
    end

    protected

    def recomendador
      @recomendador ||= Recomendador.new(self)
    end

    def def_musica(nova_musica)
      return unless nova_musica

      @reproduzidas << nova_musica
      nova_musica
    end

    def musica_aleatoria
      musicas.sort { rand }.first
    end
  end
end
