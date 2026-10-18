# Executive summary - Healthcare Appointment No-Show Analysis

**Tool:** MySQL  
**Records:** 110,527 appointments

## Business problem
Missed appointments can reduce the efficient use of appointment capacity. This study examines patterns associated with attendance to inform further operational investigation.

## Findings
1. **Overall attendance:** 22,319 appointments were missed (**20.19%**).
2. **Booking lead time:** No-show rates increased from **4.65%** for same-day bookings to **33.00%** for bookings more than 30 days in advance.
3. **SMS reminders:** Overall missed-appointment rates were **27.57%** for SMS-associated appointments and **16.70%** for those without SMS. However, the SMS group had a longer average lead time (**19.02** vs **6.01** days). Within comparable waiting-time bands, SMS-associated appointments had lower no-show rates; in the age-plus-wait analysis, this held for **19 of 20** comparable groups. This is an observational comparison, not proof of effectiveness.
4. **Demographics:** Adults aged **18–34** had the highest age-group no-show rate (**23.98%**); patients aged **65+** had the lowest (**15.50%**). Gender rates differed little (**20.31%** female, **19.97%** male).
5. **Geography:** **SANTOS DUMONT** had the highest no-show rate (**28.92%**) among neighbourhoods with at least 100 appointments. **JARDIM CAMBURI** had the most missed appointments (**1,465**).
6. **Correlation:** Neighbourhood-level Pearson correlation between mean lead time and no-show rate was **r = 0.166**, a weak positive association.

## Recommendations
- Review appointment confirmation procedures for longer lead times.
- Evaluate targeted reminder approaches rather than relying on unadjusted SMS comparisons.
- Investigate barriers affecting younger adults.
- Combine missed counts with no-show rates when prioritising neighbourhoods.
- Monitor changes and assess interventions before drawing causal conclusions.

## Limitations
The analysis is observational; patient-level repeat appointments and unmeasured factors may influence results. Five negative waiting-time records were excluded where relevant. Neighbourhood correlation is unweighted. This portfolio dataset is not NHS patient data.
