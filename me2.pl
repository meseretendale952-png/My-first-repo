/* =======================================================
   ADVANCED MEDICAL EXPERT SYSTEM (ENGLISH VERSION)
   Includes: Patient Info, Initial Symptoms, and Treatment
   ======================================================= */

:- dynamic yes/1, no/1.

/* 1. ENTRY POINT */
start :-
    clear_stored_data,
    format('~n=========================================~n'),
    format('     MEDICAL DIAGNOSIS & TREATMENT      ~n'),
    format('=========================================~n'),

    /* Basic Patient Info */
    write('Patient Name (end with .): '), read(Name),
    write('Patient Age (end with .): '), read(Age),
    
    format('~nWelcome, ~w!~n', [Name]),
    format('Please enter 2 symptoms you have right now (e.g., fever. chills.):~n'),

    /* Initial Patient Symptoms */
    write('First Symptom: '), read(S1), assertz(yes(S1)),
    write('Second Symptom: '), read(S2), assertz(yes(S2)),

    format('~nThank you. Now the doctor will ask a few more questions.~n~n'),

    /* Run Diagnosis and Treatment */
    (diagnose(Disease) ->
        treatment(Disease, Advice, Medicine),
        format('~n=========================================~n'),
        format('REPORT FOR: ~w (Age: ~w)~n', [Name, Age]),
        format('DIAGNOSIS:  ~w~n', [Disease]),
        format('-----------------------------------------~n'),
        format('TREATMENT:  ~w~n', [Advice]),
        format('MEDICINE:   ~w~n', [Medicine]),
        format('=========================================~n')
    ;
        format('~nSorry ~w, the doctor could not find a match for those symptoms.~n', [Name])),
    
    clear_stored_data.

/* 2. KNOWLEDGE BASE (DISEASES) */

diagnose(covid19) :-
    symptom(fever),
    symptom(dry_cough),
    symptom(loss_of_taste_or_smell),
    symptom(fatigue).

diagnose(flu) :-
    symptom(fever),
    symptom(chills),
    symptom(body_aches),
    \+ symptom(loss_of_taste_or_smell).

diagnose(malaria) :-
    symptom(high_fever),
    symptom(shaking_chills),
    symptom(headache),
    symptom(nausea).

diagnose(common_cold) :-
    symptom(runny_nose),
    symptom(sneezing),
    symptom(sore_throat),
    \+ symptom(fever).

/* 3. TREATMENT & MEDICINE DATABASE */

treatment(covid19, 
          'Complete home isolation for 14 days.', 
          'Paracetamol, Vitamin C, and Zinc supplements.').

treatment(flu, 
          'Take bed rest and drink plenty of warm fluids.', 
          'Oseltamivir (Tamiflu) or Ibuprofen for aches.').

treatment(malaria, 
          'Requires clinical monitoring and blood tests.', 
          'Artemether and Lumefantrine (Coartem).').

treatment(common_cold, 
          'Stay warm and use steam inhalation.', 
          'Antihistamines and Vitamin C.').

/* 4. INFERENCE ENGINE */

symptom(S) :-
    (yes(S) -> true ;
    (no(S) -> fail ;
    ask(S))).

ask(S) :-
    format('Does the patient have ~w? (y/n): ', [S]),
    read(Reply),
    ( (Reply == y ; Reply == yes) -> assertz(yes(S)) ;
      assertz(no(S)), fail ).

/* 5. DATABASE CLEANUP */
clear_stored_data :-
    retractall(yes(_)),
    retractall(no(_)).