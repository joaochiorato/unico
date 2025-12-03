# Protótipo Curtume - ERP Web + Coletor

Este projeto contém um protótipo em Flutter com:

- ERP Web (Roteiro Produtivo + Ordem de Produção) – entrada padrão em `lib/main.dart`
- Coletor Mobile (Apontamento de Produção) – entrada em `lib/main_coletor.dart`

## Como usar

1. Crie uma pasta no seu ambiente de desenvolvimento e extraia o conteúdo deste projeto.
2. Dentro da pasta do projeto, execute:

```bash
flutter pub get
flutter create .
```

O comando `flutter create .` irá gerar as pastas de plataforma (android, web, windows, etc.) se ainda não existirem.

### Executar ERP (Web ou Desktop)

```bash
flutter run -d chrome
# ou
flutter run -d windows
```

O ERP usa `lib/main.dart` como entry point.

### Executar Coletor (Mobile ou Web)

```bash
flutter run -t lib/main_coletor.dart -d chrome
# ou apontando para um dispositivo Android
flutter run -t lib/main_coletor.dart -d <id_do_dispositivo>
```

Os dados são todos mockados em memória, seguindo o fluxo do teste de mesa:

- Produto CSA001 + Classifi 7
- Roteiro herdado do artigo PRP001 – QUARTZO
- ORP com chave_fato simulada `XYD459939`
