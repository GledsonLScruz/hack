import 'package:flutter/material.dart';

class RoadMapTab extends StatelessWidget {
  const RoadMapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const Text(
            'Your Career RoadMap',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Guiding you from high school to college',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),

          // Recommended Courses Section
          _buildSectionHeader('Recommended Courses', Icons.school),
          const SizedBox(height: 16),
          _buildRecommendedCourses(),
          const SizedBox(height: 32),

          // Opportunities Section
          _buildSectionHeader('Opportunities & Discounts', Icons.local_offer),
          const SizedBox(height: 16),
          _buildOpportunities(),
          const SizedBox(height: 32),

          // Upcoming Events Section
          _buildSectionHeader('Upcoming Events', Icons.event),
          const SizedBox(height: 16),
          _buildEvents(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.deepPurple),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedCourses() {
    // TODO: Replace with actual data from API
    final courses = [
      {
        'name': 'Computer Science',
        'university': 'MIT',
        'match': 95,
      },
      {
        'name': 'Software Engineering',
        'university': 'Stanford University',
        'match': 88,
      },
      {
        'name': 'Data Science',
        'university': 'UC Berkeley',
        'match': 82,
      },
      {
        'name': 'Information Systems',
        'university': 'Carnegie Mellon',
        'match': 75,
      },
      {
        'name': 'Business Administration',
        'university': 'Harvard University',
        'match': 68,
      },
    ];

    return Column(
      children: courses.map((course) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildCourseCard(
            name: course['name'] as String,
            university: course['university'] as String,
            matchPercent: course['match'] as int,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCourseCard({
    required String name,
    required String university,
    required int matchPercent,
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to course details
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Course Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.school,
                  color: Colors.deepPurple,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Course Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_city,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            university,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Match Percentage
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
        ),
      ),
    );
  }

  Widget _buildOpportunities() {
    // TODO: Replace with actual data from API
    final opportunities = [
      {
        'title': 'Harvard University - Merit Scholarship',
        'discount': '50%',
        'description':
            'Full tuition scholarship for students with exceptional academic performance and leadership qualities.',
        'universities': ['Harvard University', 'MIT', 'Stanford University'],
      },
      {
        'title': 'STEM Excellence Program',
        'discount': '30%',
        'description':
            'Scholarship program for students pursuing STEM fields with demonstrated passion and achievement in science and technology.',
        'universities': [
          'UC Berkeley',
          'Carnegie Mellon',
          'Georgia Tech',
          'Caltech'
        ],
      },
      {
        'title': 'First Generation College Student Grant',
        'discount': '40%',
        'description':
            'Financial aid for first-generation college students to support their educational journey.',
        'universities': ['Yale University', 'Princeton University', 'Columbia'],
      },
    ];

    return Column(
      children: opportunities.map((opportunity) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildOpportunityCard(
            title: opportunity['title'] as String,
            discount: opportunity['discount'] as String,
            description: opportunity['description'] as String,
            universities: opportunity['universities'] as List<String>,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOpportunityCard({
    required String title,
    required String discount,
    required String description,
    required List<String> universities,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to opportunity details
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and discount
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.local_offer,
                      color: Colors.amber,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Discount Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green, width: 1.5),
                    ),
                    child: Text(
                      discount,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              // Universities List
              const Text(
                'Applies to:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: universities.map((university) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      university,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEvents() {
    // TODO: Replace with actual data from API
    final events = [
      {
        'title': 'MIT Open House 2025',
        'type': 'Presencial',
        'location': 'Cambridge, MA',
        'date': '2025-03-15',
      },
      {
        'title': 'Virtual Career Fair - Tech Industry',
        'type': 'Online',
        'location': 'Virtual Event',
        'date': '2025-02-20',
      },
      {
        'title': 'Stanford University Campus Tour',
        'type': 'Presencial',
        'location': 'Stanford, CA',
        'date': '2025-03-28',
      },
      {
        'title': 'STEM Scholarship Workshop',
        'type': 'Online',
        'location': 'Virtual Event',
        'date': '2025-02-10',
      },
      {
        'title': 'College Application Bootcamp',
        'type': 'Presencial',
        'location': 'São Paulo, SP',
        'date': '2025-04-05',
      },
    ];

    return Column(
      children: events.map((event) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildEventCard(
            title: event['title'] as String,
            type: event['type'] as String,
            location: event['location'] as String,
            date: event['date'] as String,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEventCard({
    required String title,
    required String type,
    required String location,
    required String date,
  }) {
    final isPresencial = type.toLowerCase() == 'presencial';
    final typeColor = isPresencial ? Colors.blue : Colors.purple;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to event details
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and type
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isPresencial ? Icons.place : Icons.computer,
                      color: typeColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: typeColor, width: 1.5),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: typeColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Location
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      location,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(date),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

