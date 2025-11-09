# 🎓 Plataforma de Mentoria e Orientação de Carreira

Uma aplicação mobile desenvolvida em Flutter que conecta estudantes do ensino médio com mentores experientes, oferecendo orientação personalizada de carreira, recomendações de cursos e oportunidades educacionais.

## 📱 Sobre o Projeto

Esta plataforma foi desenvolvida para ajudar jovens estudantes a traçarem seus caminhos profissionais, conectando-os com mentores qualificados e fornecendo roadmaps personalizados baseados em seus interesses, localização e pontos fortes.

## ✨ Funcionalidades Principais

### 🔐 Autenticação e Cadastro

- **Sistema de Login Seguro**
  - Autenticação via email e senha
  - Tokens de acesso (OAuth2)
  - Validação de credenciais em tempo real
  - Mensagens de erro personalizadas

- **Fluxo de Cadastro Completo**
  - Informações pessoais (nome, email, senha)
  - Dados demográficos (cidade, estado, bairro, gênero, raça)
  - Informações acadêmicas (escola, atividades extracurriculares)
  - Perfil profissional (áreas de interesse, pontos fortes, objetivos)
  - Formação acadêmica (faculdade, mestrado, doutorado, PhD)
  - Experiências profissionais e LinkedIn
  - Escolha entre perfil de Aluno ou Mentor

### 👨‍🎓 Funcionalidades para Alunos

#### 🗺️ RoadMap Personalizado
- **Geração Inteligente de Roadmap**
  - Baseado em interesses, localização e pontos fortes
  - Algoritmo de matching personalizado
  - Atualização automática com base no perfil

- **Cursos Recomendados**
  - Cursos universitários com score de compatibilidade
  - Informações detalhadas (instituição, duração, localização, avaliação)
  - Badge de match (80%+ verde, 60%+ laranja)
  - Filtros por tipo (graduação, técnico, online)

- **Cursos Online**
  - Plataformas reconhecidas (edX, Coursera, etc.)
  - Indicação de certificado
  - Duração em horas
  - Nível de dificuldade (iniciante, intermediário, avançado)
  - Links diretos para inscrição

- **Cursos Técnicos**
  - Instituições como SENAC
  - Duração e localização
  - Descrição detalhada dos programas

- **Bolsas de Estudo**
  - Oportunidades de bolsas (ProUni, etc.)
  - Porcentagem de cobertura
  - Prazos de inscrição
  - Instituições aplicáveis
  - Requisitos detalhados

- **Oportunidades de Entrada**
  - Estágios e programas de trainee
  - Tipo de empresa (startup, multinacional)
  - Modalidade (presencial, híbrido, remoto)
  - Requisitos e qualificações necessárias

- **Eventos de Networking**
  - Conferências e encontros profissionais
  - Tipo (presencial/online)
  - Data e localização
  - Descrição do evento

- **Habilidades para Desenvolver**
  - Lista priorizada de skills
  - Categoria (técnica, soft skill)
  - Prioridade (essencial, importante)
  - Onde aprender cada habilidade

- **Mercado de Trabalho**
  - Salário inicial e para profissionais experientes
  - Áreas em alta demanda
  - Principais empregadores
  - Tendências do mercado

- **Sistema de Cache Inteligente**
  - Cache de 1 dia para roadmap
  - Carregamento instantâneo em acessos subsequentes
  - Pull-to-refresh para atualização manual

#### 👥 Busca de Mentores
- **Sistema de Matching Avançado**
  - Algoritmo que considera múltiplos fatores
  - Score geográfico (proximidade)
  - Score de interesses comuns
  - Score semântico (compatibilidade de perfil)
  - Pontuação bônus

- **Perfil Detalhado dos Mentores**
  - Nome, cargo e formação
  - Localização
  - Áreas de interesse
  - Pontos fortes
  - Sobre o mentor
  - Badge de verificação

- **Solicitação de Mentoria**
  - Mensagem personalizada pré-preenchida
  - Editor de mensagem customizável
  - Limite de 500 caracteres
  - Validação de campos
  - Feedback visual (loading, sucesso, erro)
  - Histórico de solicitações

- **Cache de Mentores**
  - Cache de 1 dia
  - Atualização automática
  - Pull-to-refresh disponível

#### 👤 Perfil do Aluno
- **Visualização de Dados**
  - Foto de perfil (ou inicial colorida)
  - Nome e email
  - Badge de função (Aluno)
  - Áreas de interesse em chips coloridos
  - Pontos fortes destacados
  - Carregamento instantâneo (dados locais)

- **Funcionalidades**
  - Botão de edição de perfil (em desenvolvimento)
  - Logout com confirmação
  - Limpeza automática de todos os caches

### 👨‍🏫 Funcionalidades para Mentores

#### 📬 Solicitações Recebidas
- **Gerenciamento de Solicitações**
  - Lista de todas as solicitações recebidas
  - Status visual (pendente, aceito, rejeitado)
  - Informações do mentee (nome, localização, áreas de interesse)
  - Mensagem completa do solicitante
  - Timestamp relativo ("2h atrás", "Ontem")

- **Ações sobre Solicitações**
  - Aceitar solicitação
  - Rejeitar solicitação
  - Visualizar perfil completo do mentee
  - Responder com mensagem personalizada

- **Interface Intuitiva**
  - Cards organizados por data
  - Badges coloridos por status
  - Ícones representativos
  - Empty state quando não há solicitações

- **Cache de Solicitações**
  - Cache de 5 minutos (mais frequente para atualizações em tempo real)
  - Pull-to-refresh
  - Contador de solicitações no header

#### 👤 Perfil do Mentor
- **Mesmo sistema do perfil de aluno**
  - Badge de função (Mentor)
  - Todas as funcionalidades de visualização
  - Logout com limpeza de cache

## 🎨 Design e Interface

### Paleta de Cores
- **Cor Principal**: Laranja (#EC8206)
- **Cor Secundária**: Laranja claro (#F59E42)
- **Cores de Status**:
  - Verde: Aceito/Alta prioridade
  - Laranja: Pendente/Média prioridade
  - Vermelho: Rejeitado/Baixa prioridade
  - Azul: Certificados/Informações
  - Roxo: Áreas de interesse
  - Âmbar: Pontos fortes

### Componentes UI
- **Cards Modernos**
  - Bordas arredondadas (16px)
  - Sombras suaves
  - Espaçamento consistente
  - Ícones coloridos

- **Badges e Chips**
  - Indicadores de status
  - Tags de categorias
  - Scores de compatibilidade
  - Certificações

- **Gradientes**
  - Headers com gradiente laranja
  - Perfil com gradiente de fundo
  - Ícones com gradiente

- **Animações**
  - Loading spinners
  - Transições suaves
  - Pull-to-refresh
  - Feedback visual em ações

## 🔧 Tecnologias Utilizadas

### Frontend
- **Flutter** - Framework de desenvolvimento mobile
- **Dart** - Linguagem de programação
- **Material Design** - Sistema de design

### Gerenciamento de Estado
- **StatefulWidget** - Gerenciamento de estado local
- **SharedPreferences** - Armazenamento local persistente

### Networking
- **http** - Cliente HTTP para requisições API
- **dart:convert** - Serialização JSON

### Armazenamento
- **SharedPreferences** - Cache local
- **Sistema de Cache Inteligente**:
  - Roadmap: 1 dia
  - Mentores: 1 dia
  - Perfil: Dados locais (sem expiração)
  - Solicitações: 5 minutos

## 📡 Integração com API

### Endpoints Implementados

#### Autenticação
- `POST /api/v1/users/register` - Cadastro de usuário
- `POST /api/v1/users/login` - Login (OAuth2)
- `GET /api/v1/users/me` - Dados do usuário atual

#### Roadmap
- `POST /api/v1/roadmap/generate` - Geração de roadmap personalizado

#### Mentoria
- `GET /api/v1/match/mentors` - Busca de mentores compatíveis
- `POST /api/v1/mentorship-requests` - Envio de solicitação de mentoria
- `GET /api/v1/mentorship-requests/received` - Solicitações recebidas (mentores)

### Segurança
- **Headers de Autenticação**: Bearer Token
- **Content-Type**: application/json
- **Validação de Sessão**: Verificação automática de token
- **Logout Seguro**: Limpeza completa de dados locais

## 📦 Modelos de Dados

### User Models
- `UserLoggedData` - Dados do usuário logado
- `UserData` - Informações completas do usuário
- `UserProfile` - Perfil detalhado

### Course Models
- `CursoRecomendado` - Cursos universitários
- `CursoOnline` - Cursos online
- `CursoTecnico` - Cursos técnicos
- `ScholarshipOpportunity` - Bolsas de estudo
- `EntryOpportunity` - Oportunidades de entrada
- `NetworkingEvent` - Eventos de networking
- `SkillToDevelop` - Habilidades para desenvolver
- `JobMarket` - Informações do mercado de trabalho
- `RoadmapResponse` - Resposta completa do roadmap

### Mentor Models
- `Mentor` - Dados do mentor
- `MentorsResponse` - Lista de mentores

### Mentorship Models
- `MentorshipRequest` - Solicitação de mentoria
- `MentorshipUser` - Usuário em solicitação
- `ReceivedRequestsResponse` - Solicitações recebidas

## 🚀 Funcionalidades Técnicas

### Sistema de Cache
- **Estratégia Multi-Camadas**
  - Cache em memória (durante sessão)
  - Cache persistente (SharedPreferences)
  - Timestamps para expiração
  - Validação automática de validade

### Tratamento de Erros
- **Mensagens Contextualizadas**
  - Erro de conexão
  - Sessão expirada
  - Credenciais inválidas
  - Erro do servidor
  - Validação de campos

### Otimizações
- **Performance**
  - Carregamento lazy de imagens
  - Cache agressivo de dados
  - Requisições assíncronas
  - Debounce em buscas

- **UX**
  - Loading states
  - Empty states
  - Error states
  - Pull-to-refresh
  - Feedback visual imediato

### Navegação
- **Roteamento Inteligente**
  - Redirecionamento baseado em tipo de usuário
  - Proteção de rotas autenticadas
  - Deep linking preparado
  - Stack de navegação otimizado

## 📱 Telas da Aplicação

### Públicas
1. **Tela de Login**
2. **Fluxo de Cadastro** (múltiplas etapas)

### Para Alunos
1. **Home** (Bottom Navigation)
   - Tab RoadMap
   - Tab Mentores
   - Tab Perfil

### Para Mentores
1. **Home** (Bottom Navigation)
   - Tab Solicitações
   - Tab Perfil

## 🔄 Fluxo de Uso

### Para Alunos
1. Cadastro/Login
2. Visualização do roadmap personalizado
3. Exploração de cursos e oportunidades
4. Busca de mentores compatíveis
5. Envio de solicitação de mentoria
6. Acompanhamento de solicitações

### Para Mentores
1. Cadastro/Login como mentor
2. Recebimento de solicitações
3. Análise de perfis de mentees
4. Aceitação/Rejeição de solicitações
5. Gestão de mentorias ativas

## 🎯 Diferenciais

- ✅ **Matching Inteligente** - Algoritmo multi-fatorial para conexões relevantes
- ✅ **Roadmap Personalizado** - Baseado em perfil individual
- ✅ **Interface Moderna** - Design clean e intuitivo
- ✅ **Performance Otimizada** - Sistema de cache eficiente
- ✅ **Experiência Diferenciada** - Interfaces específicas para alunos e mentores
- ✅ **Dados Locais** - Funcionamento offline parcial
- ✅ **Feedback Visual** - Estados claros em todas as ações
- ✅ **Validações Robustas** - Prevenção de erros do usuário

## 🔮 Funcionalidades Futuras

- [ ] Chat em tempo real entre mentor e mentee
- [ ] Sistema de avaliações e reviews
- [ ] Agendamento de sessões de mentoria
- [ ] Videoconferência integrada
- [ ] Gamificação (conquistas, badges)
- [ ] Feed de atividades
- [ ] Notificações push
- [ ] Compartilhamento de conteúdo
- [ ] Grupos de estudo
- [ ] Eventos ao vivo

## 📄 Licença

Este projeto foi desenvolvido como parte de um hackathon.

## 👥 Contribuições

Desenvolvido com ❤️ para conectar estudantes e mentores, facilitando o acesso à educação de qualidade e orientação profissional.

---

**Versão**: 1.0.0  
**Última Atualização**: Novembro 2025  
**Plataformas**: Android, iOS  
**Linguagem**: Dart/Flutter
