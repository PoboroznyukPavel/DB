/*1)Выдать список пациентов к которым за указанный период врачи приходили для осмотра на дом*/
select Pname, PlaceName from Appointment left join Appointment_place on Appointment.ID_place =  Appointment_place.ID_Place left join Patient on Appointment.ID_P =  Patient.ID_P
where (Appointment_place.ID_Place != 1) and (Appointment_place.ID_Place != 2) and (Appointment_place.ID_Place != 3)

/*2)Выдать список врачей назначивших своим пациентам указанное лекарство.*/
select DName from ((Doctor full outer join Appointment on Doctor.ID_D = Appointment.ID_D) 
full outer join List_of_medicine on List_of_medicine.ID_A = Appointment.ID_A) 
full outer join Medicine on Medicine.ID_M = List_of_medicine.ID_M
where Medicine.MName = 'Цитрамон'

/*3)По определенному врачу выдать информацию, которая будет содержать сведения о том, 
    каких именно пациентов врач принял за указанный период (с указанием даты приема).*/
select Dname, PName, DateOfApp from Doctor right join Appointment on Doctor.ID_D = Appointment.ID_D left join Patient on Appointment.ID_P = Patient.ID_P
where (DateOfApp BETWEEN '01/01/2010' AND '27/04/2020') and Doctor.DName = 'Петров Иван Васильевич'

/*4)Выдать список врачей с указанием количества принятых им пациентов за последние 3 месяца.*/
select Doctor.DName, COUNT(DName) as 'Количество принятых пациентов' 
from Doctor full outer join (Patient full outer join Appointment on Patient.ID_P = Appointment.ID_P) on Doctor.ID_D = Appointment.ID_D
where DateOfApp BETWEEN '01/01/2010' AND '27/04/2020' group by Dname

/*5)Выбрать наиболее распространенные болезни за последний месяц.*/
SELECT Diagnosis, COUNT(Diagnosis) as Количество from Appointment where DateOfApp BETWEEN '01/03/2020' AND '1/04/2020' group by Diagnosis having COUNT(Diagnosis) = (
	select MAX(Количество) as 'кол-во самого частого случая' FROM(
	SELECT Diagnosis, COUNT(Diagnosis) as Количество from Appointment 
	where DateOfApp BETWEEN '01/03/2020' AND '1/04/2020'
	group by Diagnosis)m)

/*6)Выбрать все диагнозы по определенному пациенту.*/
select Diagnosis from Appointment
where ID_P = 1

/*/Приведите примеры запросов с выборкой, сортировкой, группировкой, левым, правым и внешним объединением.*/

/*/Выбрать всех докторов, у которых лечился пациент*/
select Dname from Doctor full outer join Appointment on Doctor.ID_D = Appointment.ID_D
where ID_P = 1

/*/Вывести список всех диагнозов по алфавиту которые ставились женщинам за последний месяц*/
select Diagnosis from Appointment full outer join Patient on Patient.ID_P = Appointment.ID_P
where DateOfApp BETWEEN '01/03/2010' AND '27/04/2020' and Patient.Sex = 'ж'
order by Diagnosis
 
/*/Вычислить самых старых пациентов по полу*/
select Sex, max(PBirth) as самая_ранняя_дата_рождения from Patient
group by Sex


/*выбрать всех пациентов с диагнозом "Мигрень"*/
select PName from Patient left join Appointment on Patient.ID_P = Appointment.ID_P
where Diagnosis = 'Мигрень'

/*выбрать всех докторов, принимавших пациентов в больнице*/
select DName from Doctor right join Appointment on Doctor.ID_D = Appointment.ID_D
where Appointment.ID_place = 1 or Appointment.ID_place = 2 or Appointment.ID_place = 3


/*Вывести список всех специальностей врачей, и, если такие есть, вывести ФИО доктора*/
select Doctors_specialty.Spec_Name, Doctor.Dname from Doctors_specialty left join Doctor on Doctors_specialty.ID_S = Doctor.ID_S

/*/Вывести список всех лекарств, и, если такие есть, вывести номер диагноза, при котором они выпиывались*/
select Medicine.MName, min(ID_A) from List_of_medicine right join Medicine on Medicine.ID_M = List_of_medicine.ID_M group by MName
