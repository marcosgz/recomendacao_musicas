# frozen_string_literal: true

require 'yaml'
require 'pathname'

require_relative 'recomendacao/version'
require_relative 'recomendacao/naive_baye'
require_relative 'recomendacao/recomendador'
require_relative 'recomendacao/musica'
require_relative 'recomendacao/playlist'

module Recomendacao
  def self.tokenize(term, lang: nil)
    words = (lang ? stopwords.fetch(lang, []) : stopwords.values.flatten).map do |w|
      format('\b%<w>s\b', w: Regexp.escape(w.to_s))
    end

    term.to_s
      .downcase
      .split(/(?:#{ words.join('|') })/i)
      .flat_map { |w| w.split(/\s/) }
      .map(&:strip)
      .select { |w| !w.empty? && w !~ /^\d+$/ && w !~ /^\W+$/i }
  end

  def self.stopwords
    return @stopwords if defined? @stopwords

    @stopwords = {}
    Dir[Recomendacao.root.join('data/stopwords/*.yml')].each do |filename|
      @stopwords[File.basename(filename, '.yml')] = YAML.load_file(filename)
    end
    @stopwords
  end

  def self.root
    Pathname.new(File.expand_path('../../', __FILE__))
  end
end
