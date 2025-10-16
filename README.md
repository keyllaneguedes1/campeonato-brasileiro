# 🏆 Campeonato Brasileiro - App Flutter

Aplicativo em **Flutter** para acompanhamento do **Campeonato Brasileiro**, com **interface moderna**, **estatísticas detalhadas** e **funcionalidades interativas**.

---

## ✨ Principais Funcionalidades

- 🏅 **Classificação em Tempo Real**
  - Tabela completa com zonas coloridas (Libertadores, Sul-Americana, Rebaixamento)
  - Busca rápida e estatísticas detalhadas dos times

- ❤️ **Sistema de Favoritos**
  - Adicione e gerencie times preferidos
  - Dados persistentes com armazenamento local
  - Estatísticas personalizadas dos favoritos

- 📊 **Detalhes dos Times**
  - Estatísticas da temporada
  - Gráficos de vitórias, empates e derrotas
  - Histórico de títulos conquistados

- 🔄 **Comparação entre Times**
  - Comparativos lado a lado
  - Gráficos e análises de desempenho ofensivo e defensivo

- 🎨 **Interface Moderna**
  - Design limpo e responsivo
  - Modo claro/escuro
  - Navegação por abas e rolagem fluida

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Função |
|-------------|--------|
| **Flutter** | Framework principal |
| **Dart** | Linguagem de programação |
| **Provider** | Gerenciamento de estado |
| **Shared Preferences** | Armazenamento local |
| **FL Chart** | Exibição de gráficos |
| **Material Design 3** | Sistema de design visual |

---

## 🚀 Como Executar o Projeto

### 🔧 Pré-requisitos
- Flutter SDK (3.0 ou superior)
- Dart (3.0 ou superior)
- Dispositivo Android/iOS ou navegador (para web)

### ▶️ Passos para Execução

```bash
# Clone o repositório
git clone [url-do-repositorio]
cd campeonato-brasileiro

# Instale as dependências
flutter pub get

# Execute o app
flutter run
```

### 📦 Build de Produção

```bash
flutter build apk --release
# ou
flutter build ios --release
# ou
flutter build web --release
```

---

## 📁 Estrutura do Projeto

```
lib/
├── main.dart
├── app_colors.dart
├── models/
│   ├── campeonato_model.dart
│   └── time_model.dart
├── providers/
│   └── times_provider.dart
├── services/
│   └── json_service.dart
├── screens/
│   ├── home_screen.dart
│   ├── detalhes_time_screen.dart
│   ├── comparacao_screen.dart
│   └── favoritos_screen.dart
└── widgets/
    ├── classificacao_item.dart
    ├── loading_widget.dart
    └── error_widget.dart
```

---

## 🎨 Temas e Zonas

| Zona | Posição | Cor |
|------|----------|-----|
| **Libertadores** | 1º–4º | 🟩 Verde escuro |
| **Pré-Libertadores** | 5º–6º | 🟢 Verde |
| **Sul-Americana** | 7º–12º | 🔵 Azul |
| **Rebaixamento** | 17º–20º | 🔴 Vermelho |


## 📄 Licença

Este projeto está sob a licença **MIT**.  
Consulte o arquivo `LICENSE` para mais informações.


