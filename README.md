# Recomendacao

Simples player de musicas utilizando redes bayesianas para recomendação de musicas. Tokens são gerados a partir de meta tags das músicas. Essa abordagem não é a mais precisa para recomendação. O ideal seria utilizar aprendizagem de maquina através de diferentes fontes de dados. Como por exemplo playlist de usuários.

## Dependencias

* Portaudio >= 19
* Mpg123 >= 1.14

### OSX

```
brew install portaudio
brew install mpg123
brew install graphviz # Gerar grafo
```

### Debian / Ubuntu

```
apt-get install libjack0 libjack-dev
apt-get install libportaudiocpp0 portaudio19-dev libmpg123-dev
```

## Setup

Instalar as gems
```
gem install bundler -v 1.17.2
bundle install
```

## Player CLI

Para iniciar o player basta usar o script `./bin/player` passando como argumento o caminho do diretório contendo arquivos mp3.

```
./bin/player data/musicas
```
