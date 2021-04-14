module Recomendacao
  class Recomendador

    def initialize(playlist)
      @playlist = playlist
      @nbaye = NaiveBaye.new
      @playlist.musicas.each do |musica|
        @nbaye.treinar(musica.id, *musica.keywords)
      end
    end

    def recomendar
      musica = @playlist.musica_atual
      return unless musica

      tokens = musica.keywords
      resultado = @nbaye.classificar(*tokens)
      id = (resultado.chaves_recomendadas - @playlist.reproduzidas.map(&:id)).first
      @playlist.procurar_musica_por_id(id)
    end
  end
end
