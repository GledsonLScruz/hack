# Courses API Integration Documentation

This document describes the integration with the Courses API endpoint for the RoadMap tab.

## API Endpoint

**POST** `/api/v1/roadmap/generate`

## Request

### Headers
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {access_token}
```

### Body (Optional)
```json
{
  // Add any required parameters here
}
```

## Response Format

### Success Response (200 OK)

```json
{
  "cursos_recomendados": [
    {
      "nome": "string",
      "instituicao": "string",
      "tipo": "string",
      "duracao_meses": 0,
      "match_score": 0,
      "localizacao": "string",
      "rating": 0,
      "descricao": "string",
      "link": "string"
    }
  ],
  "cursos_online": [
    {
      "nome": "string",
      "plataforma": "string",
      "tipo": "string",
      "duracao_horas": 0,
      "certificado": true,
      "descricao": "string",
      "link": "string",
      "nivel": "string"
    }
  ],
  "cursos_tecnicos": [
    {
      "nome": "string",
      "instituicao": "string",
      "duracao_meses": 0,
      "localizacao": "string",
      "descricao": "string",
      "link": "string"
    }
  ]
}
```

## Field Descriptions

### Cursos Recomendados (Recommended Courses)
These are university-level courses recommended based on the user's profile.

| Field | Type | Description |
|-------|------|-------------|
| `nome` | string | Course name |
| `instituicao` | string | Institution/University name |
| `tipo` | string | Course type (e.g., "Graduação", "Pós-graduação") |
| `duracao_meses` | integer | Duration in months |
| `match_score` | integer | Match percentage with user profile (0-100) |
| `localizacao` | string | Location (city, state) |
| `rating` | number | Course rating (0-5) |
| `descricao` | string | Course description |
| `link` | string | URL to course details |

**Match Score Color Coding:**
- 🟢 Green: 80-100% (High match)
- 🟠 Orange: 60-79% (Medium match)
- ⚪ Grey: 0-59% (Low match)

### Cursos Online (Online Courses)
These are online courses from various platforms.

| Field | Type | Description |
|-------|------|-------------|
| `nome` | string | Course name |
| `plataforma` | string | Platform name (e.g., "Coursera", "Udemy") |
| `tipo` | string | Course type |
| `duracao_horas` | integer | Duration in hours |
| `certificado` | boolean | Whether a certificate is provided |
| `descricao` | string | Course description |
| `link` | string | URL to course |
| `nivel` | string | Difficulty level (e.g., "Iniciante", "Intermediário", "Avançado") |

### Cursos Técnicos (Technical Courses)
These are technical/vocational courses.

| Field | Type | Description |
|-------|------|-------------|
| `nome` | string | Course name |
| `instituicao` | string | Institution name (e.g., "SENAI", "ETEC") |
| `duracao_meses` | integer | Duration in months |
| `localizacao` | string | Location (city, state) |
| `descricao` | string | Course description |
| `link` | string | URL to course details |

## Implementation

### Model Classes

Created in `lib/models/course_models.dart`:
- `CursoRecomendado` - Recommended course model
- `CursoOnline` - Online course model
- `CursoTecnico` - Technical course model
- `CoursesResponse` - Wrapper for all three course types

Each model includes:
- Constructor with required fields
- `fromJson()` factory for API deserialization
- `toJson()` method for serialization

### UI Components

Updated in `lib/screens/home/roadmap_tab.dart`:

**Card Builders:**
1. `_buildCursoRecomendadoCard()` - Displays recommended courses with:
   - Orange school icon
   - Match score badge (color-coded)
   - Institution name
   - Duration, location, rating, and type chips
   - Description (max 2 lines)

2. `_buildCursoOnlineCard()` - Displays online courses with:
   - Purple computer icon
   - Certificate badge (if applicable)
   - Platform name
   - Duration and level chips
   - Description (max 2 lines)

3. `_buildCursoTecnicoCard()` - Displays technical courses with:
   - Teal engineering icon
   - Institution name
   - Duration and location chips
   - Description (max 2 lines)

**Helper Methods:**
- `_buildSubSectionHeader()` - Orange-accented section headers
- `_buildDetailChip()` - Reusable info chips with icons

### Layout Structure

```
RoadMap Tab
├── Cursos Recomendados (Main section)
│   ├── Course Card 1
│   ├── Course Card 2
│   └── ...
├── Cursos Online (Subsection)
│   ├── Course Card 1
│   ├── Course Card 2
│   └── ...
└── Cursos Técnicos (Subsection)
    ├── Course Card 1
    ├── Course Card 2
    └── ...
```

## API Integration Steps

### 1. Add Endpoint to API Config

Update `lib/config/api_config.dart`:

```dart
class ApiConfig {
  // ... existing code ...
  
  static const String coursesEndpoint = '/api/v1/courses';
  
  static String get coursesUrl => '$baseUrl$coursesEndpoint';
}
```

### 2. Create API Service (Recommended)

Create `lib/services/courses_service.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/course_models.dart';

class CoursesService {
  /// Fetch courses for the current user
  static Future<CoursesResponse> fetchCourses({String? accessToken}) async {
    try {
      final headers = {
        ...ApiConfig.defaultHeaders,
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      };

      final response = await http.get(
        Uri.parse(ApiConfig.coursesUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return CoursesResponse.fromJson(data);
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }
}
```

### 3. Update RoadMap Tab

Modify `lib/screens/home/roadmap_tab.dart`:

```dart
import 'package:flutter/material.dart';
import '../../models/course_models.dart';
import '../../services/courses_service.dart';

class RoadMapTab extends StatefulWidget {
  const RoadMapTab({Key? key}) : super(key: key);

  @override
  State<RoadMapTab> createState() => _RoadMapTabState();
}

class _RoadMapTabState extends State<RoadMapTab> {
  bool _isLoading = true;
  String? _errorMessage;
  CoursesResponse? _coursesData;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // TODO: Get access token from secure storage
      final courses = await CoursesService.fetchCourses();
      
      if (mounted) {
        setState(() {
          _coursesData = courses;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro ao carregar cursos: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCourses,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    // Use _coursesData to build the UI
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 24),

            // Recommended Courses
            _buildSectionHeader('Cursos Recomendados'),
            const SizedBox(height: 16),
            _buildRecommendedCourses(),
            
            // ... rest of the sections
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedCourses() {
    final cursos = _coursesData?.cursosRecomendados ?? [];
    
    if (cursos.isEmpty) {
      return _buildEmptyState('Nenhum curso recomendado disponível');
    }

    return Column(
      children: cursos.map((curso) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildCursoRecomendadoCard(curso.toJson()),
        );
      }).toList(),
    );
  }
  
  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
```

## Error Handling

### Possible Errors

| Status Code | Description | Handling |
|-------------|-------------|----------|
| 200 | Success | Parse and display courses |
| 401 | Unauthorized | Redirect to login |
| 404 | Not found | Show "No courses available" message |
| 500 | Server error | Show error message with retry button |
| Network error | Connection failed | Show connection error with retry button |

### Empty States

- **No recommended courses**: "Nenhum curso recomendado disponível"
- **No online courses**: "Nenhum curso online disponível"
- **No technical courses**: "Nenhum curso técnico disponível"
- **API error**: Show error icon and retry button

## Testing

### Manual Testing

1. **Mock Data Testing** (Current Implementation)
   - Run the app with mock data
   - Verify all three course types display correctly
   - Check card layouts, icons, and badges
   - Test tap interactions

2. **API Integration Testing**
   - Replace mock data with API calls
   - Test with valid access token
   - Test with invalid/expired token
   - Test with network disconnected
   - Test with empty response

### Test Cases

```dart
// Example test cases (to be implemented)
void main() {
  group('CoursesResponse', () {
    test('fromJson creates valid object', () {
      final json = {
        'cursos_recomendados': [...],
        'cursos_online': [...],
        'cursos_tecnicos': [...],
      };
      
      final response = CoursesResponse.fromJson(json);
      
      expect(response.cursosRecomendados.length, greaterThan(0));
      expect(response.cursosOnline.length, greaterThan(0));
      expect(response.cursosTecnicos.length, greaterThan(0));
    });
    
    test('handles empty arrays', () {
      final json = {
        'cursos_recomendados': [],
        'cursos_online': [],
        'cursos_tecnicos': [],
      };
      
      final response = CoursesResponse.fromJson(json);
      
      expect(response.cursosRecomendados, isEmpty);
      expect(response.cursosOnline, isEmpty);
      expect(response.cursosTecnicos, isEmpty);
    });
  });
}
```

## Future Enhancements

### Filtering & Sorting
- Filter by course type
- Filter by location
- Filter by duration
- Sort by match score
- Sort by rating

### Search
- Search courses by name
- Search by institution
- Search by keywords in description

### Favorites
- Save favorite courses
- Quick access to saved courses

### Course Details
- Navigate to detailed course page
- Show full description
- Show enrollment information
- Show prerequisites
- Show syllabus

### Sharing
- Share course via social media
- Share via email
- Copy course link

### Analytics
- Track course views
- Track course clicks
- Track user engagement

## Security Considerations

1. **Access Token**: Always include the access token in the Authorization header
2. **HTTPS**: Ensure all API calls use HTTPS
3. **Token Refresh**: Handle token expiration gracefully
4. **Data Validation**: Validate all data from API before displaying
5. **Error Messages**: Don't expose sensitive error details to users

## Performance Optimization

1. **Caching**: Cache API responses for a short period (e.g., 5 minutes)
2. **Pagination**: If the API supports pagination, implement it
3. **Lazy Loading**: Load courses as user scrolls
4. **Image Optimization**: If course images are added, optimize loading
5. **Debouncing**: Debounce search/filter operations

## Troubleshooting

### Common Issues

**Issue**: Courses not loading
- **Solution**: Check network connection, verify API endpoint, check access token

**Issue**: Match score colors not showing correctly
- **Solution**: Verify `match_score` is an integer between 0-100

**Issue**: Cards not displaying properly
- **Solution**: Check that all required fields are present in API response

**Issue**: "Certificado" badge not showing for online courses
- **Solution**: Verify `certificado` field is a boolean in API response

## Support

For API-related issues, contact the backend team.
For UI/UX issues, refer to the design documentation.

---

**Last Updated**: 2025-11-09
**Version**: 1.0.0

