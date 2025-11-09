# API Integration Guide

## Overview

The app is now fully integrated with the backend API:
- **Sign-Up**: User registration data is sent to `/api/v1/users/register`
- **Login**: User authentication via `/api/v1/users/login`

---

## Configuration

### Update API Base URL

Edit `lib/config/api_config.dart`:

```dart
class ApiConfig {
  static const String baseUrl = 'https://your-actual-api-url.com';
  // ...
}
```

---

## API Endpoints

### 1. POST `/api/v1/users/login`

**Description:** Authenticate user and return access token

**Request Body:**

```json
{
  "grant_type": "password",
  "username": "user@example.com",
  "password": "senha123",
  "scope": ""
}
```

**Headers:**
- `Content-Type: application/json`
- `Accept: application/json`

**Success Response:**
- Status Code: `200`
- Body: 
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_in": 3600
}
```

**Error Responses:**
- Status Code: `400` or `401` (Invalid credentials)
- Body:
```json
{
  "detail": "Email ou senha inválidos"
}
```

---

### 2. POST `/api/v1/users/register`

**Request Body:**

```json
{
  "email": "user@example.com",
  "nome": "string",
  "senha": "string",
  "is_mentor": true,
  "cidade": "string",
  "estado": "string",
  "bairro": "string",
  "genero": "string",
  "cor_raca": "string",
  "is_pcd": true,
  "nome_escola": "string",
  "localidade_escola": "string",
  "pontos_fortes": "string",
  "areas_interesse": "string",
  "atividades_extracurriculares": "string",
  "renda_familiar": "string",
  "formacao_academica": "string",
  "cidade_atual": "string",
  "estado_atual": "string",
  "sobre": "string",
  "disponibilidade": "string",
  "objetivos": "string",
  "cargo_atual": "string",
  "local_pretende_trabalhar_ou_estudar_1": "string",
  "local_pretende_trabalhar_ou_estudar_2": "string",
  "local_pretende_trabalhar_ou_estudar_3": "string",
  "nome_faculdade": "string",
  "localidade_faculdade": "string",
  "nome_mestrado": "string",
  "localidade_mestrado": "string",
  "nome_doutorado": "string",
  "localidade_doutorado": "string",
  "nome_phd": "string",
  "localidade_phd": "string",
  "experiencias": "string",
  "linkedin_id": "string"
}
```

**Headers:**
- `Content-Type: application/json`
- `Accept: application/json`

**Success Response:**
- Status Code: `200` or `201`
- Body: (depends on your API)

**Error Response:**
- Status Code: `4xx` or `5xx`
- Body: 
```json
{
  "message": "Error description",
  "error": "Error details"
}
```

---

## Data Mapping

### From Sign-Up Flow to API

| Sign-Up Field | API Field | Notes |
|---------------|-----------|-------|
| `email` | `email` | User's email |
| `name` | `nome` | User's full name |
| `password` | `senha` | User's password |
| `isMentor` | `is_mentor` | Boolean: true for mentor, false for mentee |
| `menteeCity` / `mentorHometownCity` | `cidade` | Based on role |
| `menteeState` / `mentorHometownState` | `estado` | Based on role |
| `menteeNeighborhood` | `bairro` | Only for mentees |
| `menteeGender` / `mentorGender` | `genero` | Based on role |
| `menteeColorRace` / `mentorColorRace` | `cor_raca` | Based on role |
| `menteeIsDisabled` / `mentorIsDisabled` | `is_pcd` | Based on role |
| `menteeSchoolName` / `mentorHighSchoolName` | `nome_escola` | Based on role |
| `menteeSchoolLocation` / `mentorHighSchoolLocation` | `localidade_escola` | Based on role |
| `menteeStrengths` / `mentorStrengths` | `pontos_fortes` | Based on role |
| `menteeAreasOfInterest` / `mentorAreasOfInterest` | `areas_interesse` | Based on role |
| `mentorExtracurricularActivities` | `atividades_extracurriculares` | Mentor only |
| `mentorFamilyIncome` | `renda_familiar` | Mentor only |
| `mentorEducationLevel` | `formacao_academica` | Mentor only |

### Additional Optional Fields

These fields are included in the API request but are currently empty (can be populated in future):

- `sobre` - About/bio
- `disponibilidade` - Availability
- `objetivos` - Goals/objectives
- `cargo_atual` - Current position
- `local_pretende_trabalhar_ou_estudar_1/2/3` - Desired work/study locations
- `nome_faculdade` - College name
- `localidade_faculdade` - College location
- `nome_mestrado` - Master's degree name
- `localidade_mestrado` - Master's location
- `nome_doutorado` - Doctorate name
- `localidade_doutorado` - Doctorate location
- `nome_phd` - PhD name
- `localidade_phd` - PhD location
- `experiencias` - Experiences
- `linkedin_id` - LinkedIn profile ID

---

## Implementation Details

### Files Modified

1. **`lib/models/signup_data_new.dart`**
   - Added `toApiJson()` method
   - Added optional fields for future use
   - Maps internal data structure to API format

2. **`lib/screens/signup_flow/screens/submission_screen.dart`**
   - Enabled HTTP API call
   - Uses `toApiJson()` for data formatting
   - Handles success/error responses
   - Translated messages to Portuguese

3. **`lib/screens/login_screen.dart`**
   - Integrated with login API endpoint
   - Sends username and password
   - Handles authentication responses
   - Error handling with Portuguese messages
   - TODO: Token storage implementation

4. **`lib/config/api_config.dart`** (NEW)
   - Centralized API configuration
   - Easy to update base URL
   - Reusable headers
   - Both login and register endpoints

---

## Testing

### Current Status
The API integration is **ACTIVE**. The app will attempt to connect to the configured API endpoints for both login and registration.

### To Test Locally

**Login Flow:**
1. Update `lib/config/api_config.dart` with your API URL
2. Ensure your API is running and accessible
3. Enter email and password on login screen
4. Tap "Entrar"
5. Check API logs for POST to `/api/v1/users/login`

**Sign-Up Flow:**
1. Tap "Criar Conta" on login screen
2. Complete the sign-up flow
3. Submit the form
4. Check API logs for POST to `/api/v1/users/register`

### Mock Data for Testing

**Login Request:**
```json
{
  "grant_type": "password",
  "username": "user@example.com",
  "password": "senha123",
  "scope": ""
}
```

**Sign-Up Data:**
The app collects real user input. Sample data:

**Mentee:**
```json
{
  "email": "aluno@example.com",
  "nome": "João Silva",
  "senha": "senha123",
  "is_mentor": false,
  "cidade": "São Paulo",
  "estado": "SP",
  "bairro": "Centro",
  "genero": "Masculino",
  "cor_raca": "Pardo",
  "is_pcd": false,
  "nome_escola": "Escola Estadual",
  "localidade_escola": "São Paulo, SP",
  "pontos_fortes": "Problem Solving, Communication",
  "areas_interesse": "Computer Science, Mathematics"
}
```

**Mentor:**
```json
{
  "email": "mentor@example.com",
  "nome": "Maria Santos",
  "senha": "senha123",
  "is_mentor": true,
  "cidade": "Rio de Janeiro",
  "estado": "RJ",
  "genero": "Feminino",
  "cor_raca": "Branca",
  "is_pcd": false,
  "nome_escola": "Colégio Pedro II",
  "localidade_escola": "Rio de Janeiro, RJ",
  "pontos_fortes": "Leadership, Teamwork",
  "areas_interesse": "Engineering, Business",
  "atividades_extracurriculares": "Volunteer work, Sports",
  "renda_familiar": "R$ 5.000 - R$ 10.000",
  "formacao_academica": "Graduação Completa"
}
```

---

## Error Handling

### Network Errors
- **Message**: "Erro de conexão. Verifique sua internet."
- **Cause**: No internet connection or API unreachable
- **Action**: User can retry

### API Errors
- **Message**: Parsed from API response or default "Falha ao criar conta. Tente novamente."
- **Cause**: Validation errors, duplicate email, server errors
- **Action**: User can retry or fix data

### Success Flow
1. User completes sign-up
2. API returns 200/201
3. Success message shown
4. Auto-redirect to home screen

---

## Token Management

### Current Implementation
- Login returns access token
- Token is NOT currently stored (TODO)
- User navigates to home screen on success

### Recommended Implementation
```dart
// After successful login:
final data = jsonDecode(response.body);
final accessToken = data['access_token'];
final tokenType = data['token_type'];

// Store using flutter_secure_storage
final storage = FlutterSecureStorage();
await storage.write(key: 'access_token', value: accessToken);
await storage.write(key: 'token_type', value: tokenType);
```

### Using Token for API Calls
```dart
final storage = FlutterSecureStorage();
final token = await storage.read(key: 'access_token');

final response = await http.get(
  Uri.parse('$baseUrl/api/v1/protected-endpoint'),
  headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  },
);
```

---

## Future Enhancements

### Recommended Additions
1. **Token Storage**: Implement secure token storage (flutter_secure_storage)
2. **Token Refresh**: Handle token expiration and refresh
3. **Auto-Login**: Check for stored token on app start
4. **Logout**: Clear stored token
5. **Email Verification**: Add email verification step
6. **Password Strength**: Enforce stronger password requirements
7. **Profile Photos**: Add photo upload during sign-up
8. **Social Login**: Google/Facebook authentication
9. **Additional Fields**: Populate optional fields with dedicated screens
10. **Progress Save**: Save partial sign-up progress
11. **Analytics**: Track sign-up completion rates

---

## Security Notes

⚠️ **Important Security Considerations:**

1. **HTTPS Only**: Always use HTTPS in production
2. **Password Storage**: Passwords are sent to API - ensure backend hashes them
3. **Input Validation**: Backend must validate all inputs
4. **Rate Limiting**: Implement rate limiting on registration endpoint
5. **CORS**: Configure CORS properly for web deployment
6. **Token Storage**: If API returns auth token, store securely

---

## Troubleshooting

### Login Issues

#### Issue: "Email ou senha inválidos"
- Verify credentials are correct
- Check if user account exists
- Verify password is correct
- Check API logs for authentication errors

#### Issue: "Erro de conexão"
- Check internet connection
- Verify API URL in `api_config.dart`
- Ensure API is running
- Check firewall/network settings

### Sign-Up Issues

#### Issue: API returns 400/422
- Check request body format
- Verify required fields are populated
- Check API logs for validation errors
- Verify email is not already registered

#### Issue: API returns 500
- Check API server logs
- Verify database connection
- Check API error handling

### General Issues

#### Issue: App crashes on login/signup
- Check Flutter console for errors
- Verify API response format matches expected structure
- Check for null values in response parsing

---

## Contact

For API-related issues, contact your backend team with:
- Request body (from debug logs)
- Response status code
- Response body
- Timestamp of request

