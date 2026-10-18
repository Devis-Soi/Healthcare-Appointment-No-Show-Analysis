# Healthcare Appointment No-Show Analysis Using MySQL

## Project overview
Analysis of **110,527 healthcare appointments** to identify patterns associated with missed appointments, focusing on booking lead times, SMS reminders, patient demographics, recorded medical indicators and neighbourhood differences.

**Tool:** MySQL / MySQL Workbench. **Table:** `healthcare_appointments.appointments_clean`.

## Business problem
Missed appointments can create unused clinical capacity and complicate service planning. This project uses SQL to identify patterns that can guide further investigation and evaluation of attendance initiatives.

## Methods
Data quality checks; `CASE`-based segmentation; conditional aggregation; date differences with `DATEDIFF`; CTEs; grouped SMS comparisons; and a neighbourhood-level Pearson correlation calculation.

## Key findings
| Measure | Result |
|---|---:|
| Appointments | 110,527 |
| Missed appointments | 22,319 |
| Overall no-show rate | 20.19% |
| Valid waiting-time records | 110,522 |
| Same-day no-show rate | 4.65% |
| 1–7 days | 24.15% |
| 8–14 days | 30.47% |
| 15–30 days | 32.59% |
| Over 30 days | 33.00% |
| SMS not received: no-show rate | 16.70% |
| SMS received: no-show rate | 27.57% |
| Neighbourhood waiting-time/no-show Pearson r | 0.166 |

**Interpretation:** SMS-associated appointments had a longer mean waiting time (19.02 vs 6.01 days). Within comparable waiting-time bands, SMS-associated appointments had lower no-show rates. These observational patterns do not establish a causal effect of reminders.

Adults aged **18–34** had the highest recorded age-group no-show rate (**23.98%**); those aged **65+** had the lowest (**15.50%**). Among neighbourhoods with at least 100 appointments, **SANTOS DUMONT** had the highest no-show rate (**28.92%**); **JARDIM CAMBURI** had the most missed appointments (**1,465**).

## Recommendations
1. Investigate long-lead-time appointments and potential confirmation workflows.
2. Evaluate targeted SMS reminder strategies using controlled or carefully adjusted comparisons.
3. Explore attendance barriers for younger adults.
4. Prioritise geographic follow-up using both no-show rates and missed-appointment counts.
5. Track outcomes over time and assess interventions before scaling.

## Repository contents
- `sql/01_data_quality_checks.sql` — completeness, validity, anomalous dates
- `sql/02_exploratory_analysis.sql` — overall rate and booking patterns
- `sql/03_waiting_time_analysis.sql` — waiting-time categories
- `sql/04_sms_analysis.sql` — overall and waiting-time-adjusted comparisons
- `sql/05_demographic_analysis.sql` — age, gender and medical indicators
- `sql/06_neighbourhood_analysis.sql` — geographical rates and volumes
- `sql/07_correlation_analysis.sql` — Pearson correlation
- `data/data_dictionary.md` — columns and definitions
- `reports/executive_summary.md` — decision-maker summary

## Running the SQL
Import the appointment dataset into a MySQL database named `healthcare_appointments` with a table named `appointments_clean`. Execute the numbered scripts in MySQL Workbench. The original source columns include `Hipertension`, `Handcap`, and `` `No-show` `` (hyphenated name requires backticks).

## Limitations
Observational associations are not causal. Patients may have repeated appointments; appointment type and other potential influences are unavailable. Five negative waiting-time records are excluded from analyses requiring valid lead times. One negative-age record is excluded from age-band analysis. Neighbourhood correlation weights each neighbourhood equally, not by appointment volume.

## Dataset provenance
**Source:** [Medical Appointment No Shows — Kaggle](https://www.kaggle.com/datasets/joniarroba/noshowappointments), published by Joni Hoppen (JoniHoppen), with acknowledgement to Aquarela Analytics. Original file: `KaggleV2-May-2016.csv`.

**Dataset licence:** [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/). Credit the creator, use the data non-commercially, and share adaptations under the same licence. This project analyses the dataset and documents exclusions for invalid date and age records.

This is a public-dataset portfolio exercise, **not NHS patient data**. Raw data are not included in this package.
