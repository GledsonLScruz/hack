import 'package:flutter/material.dart';

class MentorsTab extends StatelessWidget {
  const MentorsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from API
    final mentors = [
      {
        'name': 'Ana Carolina Silva',
        'photo': null,
        'match': 95,
        'description':
            'Engenheira de Software na Google. Graduada em Ciência da Computação pela USP. Apaixonada por ensinar e ajudar jovens a alcançarem seus objetivos.',
      },
      {
        'name': 'Pedro Henrique Santos',
        'photo': null,
        'match': 88,
        'description':
            'Estudante de Mestrado em IA no MIT. Especialista em Machine Learning e Data Science. Mentor voluntário há 3 anos.',
      },
      {
        'name': 'Maria Eduarda Costa',
        'photo': null,
        'match': 85,
        'description':
            'Desenvolvedora Full Stack na Microsoft. Formada em Engenharia de Software. Focada em orientação de carreira e desenvolvimento pessoal.',
      },
      {
        'name': 'Lucas Fernandes',
        'photo': null,
        'match': 82,
        'description':
            'Empreendedor e fundador de startup de tecnologia. MBA em Gestão de Negócios. Experiência em mentoria de jovens empreendedores.',
      },
      {
        'name': 'Juliana Oliveira',
        'photo': null,
        'match': 78,
        'description':
            'Cientista de Dados na Amazon. PhD em Estatística. Especialista em orientar estudantes em carreiras STEM.',
      },
      {
        'name': 'Rafael Almeida',
        'photo': null,
        'match': 75,
        'description':
            'Arquiteto de Software na IBM. 10 anos de experiência em tecnologia. Mentor focado em desenvolvimento técnico e soft skills.',
      },
      {
        'name': 'Camila Rodrigues',
        'photo': null,
        'match': 72,
        'description':
            'Product Manager na Nubank. Formada em Administração e Tecnologia. Ajuda jovens a descobrirem suas vocações.',
      },
      {
        'name': 'Bruno Martins',
        'photo': null,
        'match': 68,
        'description':
            'Professor universitário e pesquisador. Doutor em Ciência da Computação. Experiência em orientação acadêmica.',
      },
    ];

    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Encontre seu Mentor',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Conecte-se com mentores que combinam com seu perfil',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),

        // Mentors List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: mentors.length,
            itemBuilder: (context, index) {
              final mentor = mentors[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildMentorCard(
                  context: context,
                  name: mentor['name'] as String,
                  photo: mentor['photo'] as String?,
                  matchPercent: mentor['match'] as int,
                  description: mentor['description'] as String,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMentorCard({
    required BuildContext context,
    required String name,
    required String? photo,
    required int matchPercent,
    required String description,
  }) {
    Color matchColor;
    if (matchPercent >= 80) {
      matchColor = Colors.green;
    } else if (matchPercent >= 60) {
      matchColor = Colors.orange;
    } else {
      matchColor = Colors.grey;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to mentor profile details
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ver perfil de $name'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with Photo, Name, and Match
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Photo/Initial
                  _buildProfilePhoto(name, photo),
                  const SizedBox(width: 16),

                  // Name and Match
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.verified_user,
                              size: 16,
                              color: Colors.blue[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Mentor Verificado',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Match Percentage Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: matchColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: matchColor, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: matchColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$matchPercent%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: matchColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: View full profile
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Ver perfil completo de $name'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person, size: 18),
                      label: const Text('Ver Perfil'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Connect with mentor
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Conectar com $name'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.connect_without_contact, size: 18),
                      label: const Text('Conectar'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhoto(String name, String? photoUrl) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'M';

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: photoUrl != null && photoUrl.isNotEmpty
          ? ClipOval(
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildInitialCircle(initial);
                },
              ),
            )
          : _buildInitialCircle(initial),
    );
  }

  Widget _buildInitialCircle(String initial) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple.shade300,
            Colors.deepPurple.shade600,
          ],
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

