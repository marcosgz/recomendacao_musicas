# frozen_string_literal: true

module Recomendacao
  class NaiveBaye
    def initialize
      @remover_duplicidade = false
      @assume_uniform = false
      @k = 1
      # Inicializar o hash com a estrutura de dados como padrão utilizado
      # no treino e recomendação.
      @data = Hash.new do |dh, dk|
        dh[dk] = {
          tokens: Hash.new { |th, tk| th[tk] = 0 },
          total_tokens: 0,
          examples: 0,
        }
      end
    end

    def treinar(chave, *tokens)
      tokens.uniq! if @remover_duplicidade
      # Incrementa o número de treinos para essa categoria
      @data[chave][:examples] += 1
      tokens.each do |token|
        # vocab.seen_token(token)
        # Adiciona o token para essa categoria
        adicionar_token(chave, token)
      end
    end

    def remover(chave)
      @data.delete(chave)
    end

    def classificar(*tokens)
      tokens.uniq! if @remover_duplicidade
      caclular_probabilidades(tokens).tap do |probs|
        # Adiciona o singleton_method "recomendado" no hash
        probs.extend(Resultado)
      end
    end

    module Resultado
      # Retorna a chave que tem o maior valor
      def chaves_recomendadas
        keys.sort { |a, b| self[b].to_s <=> self[a].to_s }
      end

      def recomendado
        keys.max { |a, b| self[a] <=> self[b] }
      end
    end

    protected

    # Adiciona o token para para a chave
    def adicionar_token(key, token)
      @data[key][:tokens][token] += 1
      @data[key][:total_tokens] += 1
    end

    # Calcula a probabilidade em relação aos tokens recebidos como argumento.
    # É aqui que a mágica realmente acontece!
    #
    # Formula:
    # ========
    # P(D|Pos) = (P(D) * P(Pos|D) / P(Pos)
    # The probability of getting a positive test result P(Pos) can be calulated
    # using the Sensitivity and Specificity as follows:
    # P(Pos) = [P(D) * Sensitivity] + [P(~D) * (1-Specificity))]
    # Source: https://becominghuman.ai/naive-bayes-theorem-d8854a41ea08
    def caclular_probabilidades(tokens)
      probabilidades = {}

      cat_prob = Math.log(1 / @data.keys.size.to_f)
      total_example_count = @data.sum { |_, val| val[:examples] }.to_f

      @data.each do |category, values|
        unless @assume_uniform
          # cat_prob = Math.log(@data.dig(category, :examples) / total_example_count)
          cat_prob = Math.log(values[:examples] / total_example_count)
        end

        log_probs = 0
        # denominator = (@data.dig(category, :total_tokens) + @k * @data.dig(category, :tokens).keys.size).to_f
        denominator = (values[:total_tokens] + 1 * values[:tokens].keys.size).to_f
        tokens.each do |token|
          # numerator = @data.dig(category, :tokens, token) + @k
          numerador = values.dig(:tokens, token) + 1
          log_probs += Math.log(numerador / denominator)
        end
        probabilidades[category] = log_probs + cat_prob
      end
      normalizar(probabilidades)
    end

    # Estamos usando probabilidade com logaritimos, portanto os numeros são negativos
    # e o menor numero é na realidade o mais provável. Esse método converte mantendo a
    # distancia relativa entre todas as possibilidades.
    # Dividir log prob pelo normalizador: Isso mantem os mesmos índices mas na ordem reversa.
    # Ex: -1,-1,-2  =>  -4/-1, -4/-1, -4/-2
    #   - renormalize and calculate => 4/10, 4/10, 2/10
    def normalizar(probabilidades)
      normalizer = 0
      probabilidades.each_value { |numerator| normalizer += numerator } # Apenas a soma de todos numeradores.
      renormalizer = 0
      aux = {}
      probabilidades.each do |chave, numerador|
        aux[chave] = normalizer / numerador.to_f
        renormalizer += aux[chave]
      end
      {}.tap do |result|
        aux.each do |chave, valor|
          result[chave] = valor / renormalizer.to_f
        end
      end
    end
  end
end
