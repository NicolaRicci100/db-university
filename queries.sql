

--*   EX - Query con SELECT

-- 1. Selezionare tutti gli studenti nati nel 1990 (160)
SELECT * FROM `students` WHERE `date_of_birth` >= '1990-01-01' AND `date_of_birth` <= '1990-12-31';
-- 2. Selezionare tutti i corsi che valgono più di 10 crediti (479)
SELECT * FROM `courses` WHERE `cfu` > 10;
-- 3. Selezionare tutti gli studenti che hanno più di 30 anni
SELECT * FROM `students` WHERE (YEAR(CURRENT_DATE()) - YEAR(date_of_birth)) > 30;
-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea (286)
SELECT * FROM `courses` WHERE `period` = 'I semestre' AND `year` = 1;
-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020 (21)
SELECT * FROM `exams` WHERE `date` = '2020-06-20' AND `hour` > '14:00:00';
-- 6. Selezionare tutti i corsi di laurea magistrale (38)
SELECT * FROM `degrees` WHERE `level` = 'magistrale';
-- 7. Da quanti dipartimenti è composta l'università? (12)
SELECT COUNT(*) FROM `departments`;
-- 8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50)
SELECT COUNT(*) FROM `teachers` WHERE `phone` IS NULL;



--*   EX - Query con GROUP BY

-- 1. Contare quanti iscritti ci sono stati ogni anno
SELECT COUNT(*) AS `iscritti`, YEAR(`enrolment_date`) AS `anno` FROM `students` GROUP BY YEAR(`enrolment_date`);
-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio
SELECT COUNT(*) AS `insegnanti`,`office_address` AS `indirizzo` FROM `teachers` GROUP BY `office_address`;
-- 3. Calcolare la media dei voti di ogni appello d'esame
SELECT `exam_id` AS `appello`, AVG(`vote`) AS `media_voti` FROM `exam_student` GROUP BY `exam_id`;
-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento
SELECT COUNT(`name`) AS `corsi`, `department_id` AS `dipartimento` FROM `degrees` GROUP BY `department_id`;



--*   EX - Query con JOIN

-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia
SELECT `students`.`name` AS `studenti di economia` 
FROM `students` 
JOIN `degrees` 
ON `students`.`degree_id` = `degrees`.`id` 
WHERE `degrees`.`name` = 'Corso di Laurea in Economia';
-- 2. Selezionare tutti i Corsi di Laurea del Dipartimento di Neuroscienze
SELECT `degrees`.`name` AS `corsi a neuroscienze` 
FROM `degrees` 
JOIN `departments` 
ON `degrees`.`department_id` = `departments`.`id` 
WHERE `departments`.`name` = 'Dipartimento di Neuroscienze';
-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)
SELECT `courses`.`name` AS `corsi di Fulvio`
FROM `teachers`
JOIN `course_teacher`
ON `teachers`.`id` = `course_teacher`.`teacher_id`
JOIN `courses`
ON `course_teacher`.`course_id` = `courses`.`id`
WHERE `teachers`.`name` = 'Fulvio'
AND `teachers`.`surname` = 'Amato';
-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome
SELECT `students`.`surname` AS `cognome`, `students`.`name` AS `nome`, `degrees`.`name` AS `laurea`, `departments`.`name` AS `dipartimento`
FROM `students`
JOIN `degrees`
ON `students`.`degree_id` = `degrees`.`id`
JOIN `departments`
ON `degrees`.`department_id` = `departments`.`id`
ORDER BY `students`.`surname`, `students`.`name`;
-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti
SELECT `degrees`.`name` AS `laurea`, `courses`.`name` AS `corso`, `teachers`.`name` AS `insegnante`
FROM `degrees`
JOIN `courses`
ON `degrees`.`id` = `courses`.`degree_id`
JOIN `course_teacher`
ON `courses`.`id` = `course_teacher`.`course_id`
JOIN `teachers`
ON `course_teacher`.`teacher_id` = `teachers`.`id`
ORDER BY `degrees`.`name`;
-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)
SELECT T.`name` AS `nome`, T.`surname` AS `cognome`
FROM `teachers` AS T
JOIN `course_teacher` AS CT
ON T.`id` = CT.`teacher_id`
JOIN `courses` AS C
ON CT.`course_id` = C.`id`
JOIN `degrees` AS DEG 
ON C.`degree_id` = DEG.`id`
JOIN `departments` AS DEP 
ON DEG.`department_id` = DEP.`id`
WHERE DEP.`name` = 'Dipartimento di Matematica';
-- 7. BONUS: Selezionare per ogni studente quanti tentativi d’esame ha sostenuto per superare ciascuno dei suoi esami