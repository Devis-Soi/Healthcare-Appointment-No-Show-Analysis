# Data dictionary

**Table:** `healthcare_appointments.appointments_clean`  
**Grain:** one row per appointment (110,527 records).

| Column | Meaning | Logical type |
|---|---|---|
| `PatientId` | Patient identifier; can recur across appointments | Numeric |
| `AppointmentID` | Appointment identifier | Numeric |
| `Gender` | Recorded gender (`F`, `M`) | Text |
| `ScheduledDay` | Date/time appointment was scheduled | Date/time |
| `AppointmentDay` | Appointment date/time | Date/time |
| `Age` | Recorded age in years | Integer |
| `Neighbourhood` | Recorded neighbourhood | Text |
| `Scholarship` | Social assistance indicator (0/1) | Integer |
| `Hipertension` | Recorded hypertension indicator (0/1); source spelling retained | Integer |
| `Diabetes` | Recorded diabetes indicator (0/1) | Integer |
| `Alcoholism` | Recorded alcoholism indicator (0/1) | Integer |
| `Handcap` | Recorded disability-related indicator (0–4); source spelling retained; detailed coding not verified | Integer |
| `SMS_received` | Recorded SMS reminder status (0/1) | Integer |
| `No-show` | `Yes` = missed; `No` = attended | Text |

*Logical types are descriptive; exact MySQL schema types may differ.*

## Derived fields
- `waiting_days`: `DATEDIFF(DATE(AppointmentDay), DATE(ScheduledDay))`.
- `waiting_category`: Same day; 1–7; 8–14; 15–30; Over 30 days.
- `age_group`: Under 18; 18–34; 35–49; 50–64; 65+.
- `missed_appointments`: `SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END)` (use backticks around the column name in actual SQL).
- `no_show_rate`: `100 * missed_appointments / total_appointments`.

## Quality and interpretation notes
Five appointments have negative booking lead times and are excluded from waiting-time analyses, leaving 110,522 valid records. One record has a negative age and is excluded from age-band comparisons. There are 81 distinct nonblank neighbourhoods. SMS association is not proof of SMS effectiveness.
