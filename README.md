# 🎓 EuDoAmanha

Plataforma mobile que conecta estudantes do ensino médio com mentores experientes, oferecendo orientação personalizada de carreira através de IA, recomendações inteligentes de cursos e oportunidades educacionais.

## 📱 Sobre o Projeto

**EuDoAmanha** foi desenvolvido durante o **Hackathon DEVS DE IMPACTO** para democratizar o acesso à orientação profissional. Utilizando inteligência artificial e algoritmos de matching avançados, a plataforma conecta estudantes com mentores qualificados e gera roadmaps personalizados baseados em perfil individual, localização e aspirações de carreira.

### 🏗️ Arquitetura

**Backend:**
- **FastAPI** (Python 3.12) - Framework moderno e performático
- **PostgreSQL 16 + pgvector** - Banco de dados com busca vetorial para matching inteligente
- **SQLModel** - ORM type-safe para Python
- **OpenAI API** - Geração de roadmaps personalizados e embeddings semânticos
- **JWT + bcrypt** - Autenticação segura
- **Docker Compose** - Containerização completa
- **Cloud Hetzner** - Hospedagem em nuvem

**Frontend:**
- **Flutter** - Framework cross-platform (Android/iOS)
- **Dart** - Linguagem type-safe e performática
- **Material Design 3** - Interface moderna e intuitiva
- **Sistema de Cache Inteligente** - Performance otimizada com dados locais

## ✨ Funcionalidades Principais

### 🔐 Autenticação JWT
- Login seguro com tokens JWT e criptografia bcrypt
- Fluxo de cadastro multi-etapa com validação em tempo real
- Perfis diferenciados: Aluno ou Mentor
- Sessão persistente com refresh automático

### 🤖 RoadMap com IA (Alunos)
- **Geração Inteligente via OpenAI**: Roadmaps personalizados baseados em perfil, interesses e localização
- **Recomendações Completas**: Cursos universitários, online (edX, Coursera) e técnicos (SENAC)
- **Bolsas e Oportunidades**: ProUni, estágios, trainee e eventos de networking
- **Análise de Mercado**: Salários, tendências e principais empregadores
- **Habilidades Priorizadas**: Lista de skills essenciais com fontes de aprendizado
- **Cache Inteligente**: 1 dia de cache com pull-to-refresh

### 🎯 Matching Vetorial de Mentores (Alunos)
- **Busca Semântica com pgvector**: Algoritmo multi-fatorial (geográfico, interesses, semântico)
- **Scores de Compatibilidade**: Visualização clara de match percentage
- **Solicitação Personalizada**: Mensagem pré-preenchida com IA, editável até 500 caracteres
- **Feedback em Tempo Real**: Loading states, confirmações e tratamento de erros
- **Interface Polida**: Cards modernos com gradientes, badges e ícones contextuais

### 📬 Gestão de Solicitações (Mentores)
- **Dashboard Completo**: Lista de solicitações com status visual (pendente/aceito/rejeitado)
- **Perfis Detalhados**: Informações completas dos mentees interessados
- **Timestamps Relativos**: "2h atrás", "Ontem" para melhor UX
- **Ações Rápidas**: Aceitar/rejeitar com um toque
- **Cache de 5min**: Atualização frequente para dados em tempo real

### 👤 Perfil Inteligente
- **Carregamento Instantâneo**: Dados locais do SharedPreferences (zero latência)
- **Interface Adaptativa**: Diferenciação visual entre Aluno e Mentor
- **Chips Coloridos**: Áreas de interesse e pontos fortes com design moderno
- **Avatar Dinâmico**: Inicial com gradiente quando sem foto

## 🎨 Design System

**Material Design 3** com paleta laranja (#EC8206), gradientes suaves, cards com bordas arredondadas (16px), badges coloridos por contexto, animações fluidas e estados visuais claros (loading, empty, error). Interface responsiva com pull-to-refresh e feedback imediato em todas as ações.

## 🚀 Como Rodar o App

### Pré-requisitos

- **Flutter SDK** 3.8.1 ou superior ([Instalar Flutter](https://flutter.dev/docs/get-started/install))
- **Dart** 3.8.1 ou superior (incluído no Flutter)
- **Android Studio** (para Android) ou **Xcode** (para iOS)
- **Dispositivo físico** ou **emulador** configurado

### Passos para Instalação

1. **Clone o repositório**

```bash
git clone <url-do-repositorio>
cd hackathonapp
```

2. **Instale as dependências**

```bash
flutter pub get
```

3. **Configure a URL da API**

Edite o arquivo `lib/config/api_config.dart` e configure o `baseUrl` para apontar para o backend:

```dart
static const String baseUrl = 'https://seu-backend.com'; // ou http://localhost:8000 para desenvolvimento local
```

4. **Execute o app**

Para Android/iOS (emulador ou dispositivo conectado):

```bash
flutter run
```

Para escolher um dispositivo específico:

```bash
flutter devices  # Lista dispositivos disponíveis
flutter run -d <device-id>
```

### Dependências Principais

- `flutter` - Framework mobile
- `http: ^1.2.0` - Cliente HTTP para requisições API
- `shared_preferences: ^2.2.2` - Armazenamento local persistente
- `intl: ^0.20.2` - Formatação de datas e internacionalização
- `mask_text_input_formatter: ^2.9.0` - Máscaras para campos de texto
- `cupertino_icons: ^1.0.8` - Ícones iOS

### Build para Produção

**Android (APK):**

```bash
flutter build apk --release
```

**Android (App Bundle):**

```bash
flutter build appbundle --release
```

**iOS:**

```bash
flutter build ios --release
```

### Troubleshooting

**Erro de certificado SSL (desenvolvimento local):**
- Certifique-se de que o backend está rodando e acessível
- Para testes locais, use `http://` ao invés de `https://`
- Em Android, adicione `android:usesCleartextTraffic="true"` no `AndroidManifest.xml` (apenas desenvolvimento)

**Erro ao instalar dependências:**

```bash
flutter clean
flutter pub get
```

**Problemas com cache:**

```bash
flutter clean
flutter pub cache repair
flutter pub get
```

## 🚀 Destaques Técnicos do Cliente

### Sistema de Cache Multi-Camadas
- **Roadmap/Mentores**: 1 dia | **Solicitações**: 5min | **Perfil**: Instantâneo (local)
- Timestamps automáticos, validação de expiração e pull-to-refresh

### Roteamento Inteligente
- Navegação diferenciada por tipo de usuário (Aluno vs Mentor)
- Proteção de rotas com verificação JWT
- Stack otimizado para performance

### Tratamento de Estados
- Loading, Empty, Error e Success states em todas as telas
- Feedback visual imediato com animações suaves
- Mensagens contextualizadas por tipo de erro

### Modelos Type-Safe
- 10+ modelos Dart com serialização JSON completa
- Validação de tipos em compile-time
- Helpers para parsing de dados (listas, datas, scores)

## 🎯 Diferenciais

✅ **IA Generativa** - OpenAI para roadmaps personalizados  
✅ **Busca Vetorial** - pgvector para matching semântico avançado  
✅ **Performance** - Cache inteligente com zero latência em dados locais  
✅ **UX Polida** - Material Design 3 com estados visuais claros  
✅ **Type-Safe** - Dart + SQLModel para código robusto  
✅ **Escalável** - Arquitetura containerizada com Docker

## 🏆 Hackathon DEVS DE IMPACTO

Este projeto foi desenvolvido durante o **Hackathon DEVS DE IMPACTO**, um evento focado em criar soluções tecnológicas que geram impacto social positivo. O **EuDoAmanha** nasceu da necessidade de democratizar o acesso à orientação de carreira, especialmente para jovens que não têm recursos ou conexões para receber mentoria profissional.

### Impacto Social

- 🎯 **Democratização do Acesso** - Conecta estudantes de diferentes realidades com mentores qualificados
- 🌍 **Alcance Nacional** - Sistema de matching considera localização para conexões regionais
- 💡 **Orientação Personalizada** - Roadmaps baseados no perfil individual de cada estudante
- 🤝 **Comunidade** - Cria uma rede de apoio entre estudantes e profissionais
- 📚 **Educação Acessível** - Recomenda cursos gratuitos e bolsas de estudo

## 📄 Licença

Este projeto foi desenvolvido como parte do Hackathon DEVS DE IMPACTO.

## 👥 Contribuições

Desenvolvido com ❤️ durante o **Hackathon DEVS DE IMPACTO** para conectar estudantes e mentores, facilitando o acesso à educação de qualidade e orientação profissional.

---

**Projeto**: EuDoAmanha  
**Evento**: Hackathon DEVS DE IMPACTO  
**Versão**: 1.0.0  
**Última Atualização**: Novembro 2025  
**Plataformas**: Android, iOS  
**Linguagem**: Dart/Flutter
