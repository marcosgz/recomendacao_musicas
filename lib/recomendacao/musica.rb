require 'id3tag'

module Recomendacao
  class Musica
    attr_accessor :titulo, :id, :filename

    def initialize(**attributes)
      @keywords = []
      attributes.each do |key, value|
        setter = :"#{key}="
        public_send(setter, value) if respond_to?(setter)
      end
    end

    def nome
      n = titulo
      n = mp3_info[:titulo] if n.to_s.empty?
      n = File.basename(filename) if n.to_s.empty? && file_exist?
      n.to_s
    end

    def keywords=(values)
      return unless values

      @keywords = [*values]
    end

    def keywords
      array = (@keywords + mp3_info.values_at(:artista, :album, :year))
      mp3_info[:genero]&.split(/(,|;)/i)&.each do |g|
        array.push(*[g, *Recomendacao.tokenize(g)].uniq)
      end
      array
        .map { |w| w.to_s.downcase.strip }
        .reject { |kw| kw.to_s.empty? || kw =~ /^\(?\d+\)?$/ }
    end

    def to_s
      format(
        '#<Musica id=%<id>p nome=%<nome>p file=%<file>p keywords=%<keywords>p>',
        id: id,
        nome: nome,
        file: (File.basename(filename) if file_exist?),
        keywords: keywords,
      )
    end

    def inspect
      to_s
    end

    def mp3?
      return false unless file_exist?

      File.extname(filename) == '.mp3'
    end

    protected

    def file_exist?
      return false unless filename
      File.exist?(filename)
    end

    # https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes
    def mp3_info
      info = {}
      return info unless mp3?

      ID3Tag.read(File.open(filename, 'rb')) do |tag|
        info[:artista] = tag.artist
        info[:titulo] = tag.title
        info[:album] = tag.album
        info[:genero] = tag.genre
        info[:ano] = tag.year
      end
      info
    end
  end
end
