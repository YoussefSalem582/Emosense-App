# 🔌 API Endpoints

> Complete reference of all API endpoints used by the mobile app.
> Paths are defined next to each feature / data source (`lib/features/...`). **Never** concatenate full URLs in widgets — derive from **`AppConfig.baseUrl`** and shared path fragments.

---

## Base Configuration

| Setting | Source |
|---------|--------|
| Base URL | `.env` → `API_BASE_URL` → `AppConfig.baseUrl` (`lib/core/config/app_config.dart`) |
| Dio base | `ApiClient` uses `AppConfig.baseUrl` (`lib/core/network/api_client.dart`); paths are relative to that host — see codebase for API path composition. |

> **Note:** The sample table below referencing `api/` + version may describe a deployed backend shaped like Technology 92; confirm against `lib/` (path constants evolve per feature).

## Base URL composition (conceptual)

Combine **`AppConfig.baseUrl`** with the path fragments your **`ApiClient`** calls use — do **not** assume `EnvConfig.apiVersion`; add a getter on **`AppConfig`** if you expose an API prefix in `.env`.

---

## Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/register` | Register new user (name, email, password, phone) |
| POST | `/login` | Email/password login → returns auth token |
| POST | `/logout` | Invalidate current token |
| DELETE | `/delete/account` | Soft-delete authenticated account + revoke all tokens |
| POST | `/password/forgot` | Send password reset email |
| POST | `/password/reset` | Reset password with token |
| POST | `/oauth/exchange` | Exchange Google OAuth token for app token |

---

## Jobs (legacy marketplace reference)

> Legacy **job marketplace** paths; verify in **`lib/`** whether still used by Emosense.

| GET | `/applicant/job/index` | Paginated job list (supports filters) |
| GET | `/applicant/job/show/{id}` | Job detail by ID |
| POST | `/applicant/job/store/{id}` | Apply for a job |
| GET | `/applicant/search/job` | Search jobs by keyword |

---

## Profile

### Personal & Professional

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/applicant/profile` | Full profile overview + completeness |
| GET | `/applicant/personal/details` | Personal details |
| PUT | `/applicant/personal/details` | Update personal details |
| GET | `/applicant/short/personal/details` | Short personal details (name only) |
| GET | `/applicant/professional/details` | Professional details |
| PUT | `/applicant/professional/details` | Update professional details |
| GET | `/applicant/profile-summary` | AI-generated profile summary |

### Images

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/applicant/images` | Upload profile/background image |
| GET | `/applicant/images` | Get current images |
| DELETE | `/applicant/images/{type}` | Delete image by type |

### Resume

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/applicant/upload-resume` | Upload resume file |
| GET | `/applicant/fetch-resumes` | Get uploaded resumes |
| DELETE | `/applicant/delete-resume/{type}` | Delete resume by type |

### Video

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/applicant/upload-video` | Upload intro video |
| GET | `/applicant/fetch-videos` | Get uploaded videos |
| DELETE | `/applicant/delete-video/{type}` | Delete video by type |

### Skills

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET/POST | `/applicant/skills` | List / add skills |
| PUT/DELETE | `/applicant/skills/{id}` | Update / delete skill |

### Experiences

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET/POST | `/applicant/experiences` | List / add experiences |
| PUT/DELETE | `/applicant/experiences/{id}` | Update / delete experience |

### Educations

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET/POST | `/applicant/educations` | List / add educations |
| PUT/DELETE | `/applicant/educations/{id}` | Update / delete education |

---

## KPIs

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/applicant/kpis/definitions` | KPI definitions with units and ranges |
| GET | `/applicant/kpis` | KPI entries (supports date filter) |
| POST | `/applicant/kpis` | Create KPI entry |
| PUT | `/applicant/kpis/{id}` | Update KPI entry |
| DELETE | `/applicant/kpis/{id}` | Delete KPI entry |

---

## Attendance

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/applicant/attendance/statuses` | Available attendance statuses |
| GET | `/applicant/attendance/current` | Current attendance record |
| POST | `/applicant/attendance/check-in` | Clock in |
| POST | `/applicant/attendance/check-out` | Clock out |
| PUT | `/applicant/attendance/status/update` | Update attendance status |
| GET | `/applicant/attendance/Schedule` | Attendance schedule history |

---

## Lookups

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/lookups` | General lookups (job types, locations, etc.) |
| GET | `/lookups/industries/search` | Search industries by keyword |
| GET | `/lookups/countries` | Country list |
| GET | `/lookups/currencies` | Currency list |
| GET | `/lookups/work-levels` | Work level options |
| GET | `/lookups/availabilities` | Availability options |
| GET | `/lookups/functional-areas` | Functional area options |
| GET | `/lookups/international/codes` | International dialling codes |
| GET | `/lookups/marital/statuses` | Marital status options |
| GET | `/lookups/nationalities` | Nationality list |
| GET | `/lookups/work/shifts` | Work shift options |
| GET | `/lookups/genders` | Gender options |

---

## Essential Info

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/applicant/essential/info` | AI-extracted profile info (OpenAI) |

---

## Dashboard

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/applicant/dashboard` | Applicant dashboard stats |

---

## Adding a New Endpoint

1. Add the path constant to `lib/core/api/api_endpoints.dart`
2. Use it in your data source via `ApiClient`
3. Update this doc

See [04_how_to_add_new_api.md](04_how_to_add_new_api.md) for the full end-to-end guide.
