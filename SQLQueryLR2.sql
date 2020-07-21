/*1)������ ������ ��������� � ������� �� ��������� ������ ����� ��������� ��� ������� �� ���*/
select Pname, PlaceName from Appointment left join Appointment_place on Appointment.ID_place =  Appointment_place.ID_Place left join Patient on Appointment.ID_P =  Patient.ID_P
where (Appointment_place.ID_Place != 1) and (Appointment_place.ID_Place != 2) and (Appointment_place.ID_Place != 3)

/*2)������ ������ ������ ����������� ����� ��������� ��������� ���������.*/
select DName from ((Doctor full outer join Appointment on Doctor.ID_D = Appointment.ID_D) 
full outer join List_of_medicine on List_of_medicine.ID_A = Appointment.ID_A) 
full outer join Medicine on Medicine.ID_M = List_of_medicine.ID_M
where Medicine.MName = '��������'

/*3)�� ������������� ����� ������ ����������, ������� ����� ��������� �������� � ���, 
    ����� ������ ��������� ���� ������ �� ��������� ������ (� ��������� ���� ������).*/
select Dname, PName, DateOfApp from Doctor right join Appointment on Doctor.ID_D = Appointment.ID_D left join Patient on Appointment.ID_P = Patient.ID_P
where (DateOfApp BETWEEN '01/01/2010' AND '27/04/2020') and Doctor.DName = '������ ���� ����������'

/*4)������ ������ ������ � ��������� ���������� �������� �� ��������� �� ��������� 3 ������.*/
select Doctor.DName, COUNT(DName) as '���������� �������� ���������' 
from Doctor full outer join (Patient full outer join Appointment on Patient.ID_P = Appointment.ID_P) on Doctor.ID_D = Appointment.ID_D
where DateOfApp BETWEEN '01/01/2010' AND '27/04/2020' group by Dname

/*5)������� �������� ���������������� ������� �� ��������� �����.*/
SELECT Diagnosis, COUNT(Diagnosis) as ���������� from Appointment where DateOfApp BETWEEN '01/03/2020' AND '1/04/2020' group by Diagnosis having COUNT(Diagnosis) = (
	select MAX(����������) as '���-�� ������ ������� ������' FROM(
	SELECT Diagnosis, COUNT(Diagnosis) as ���������� from Appointment 
	where DateOfApp BETWEEN '01/03/2020' AND '1/04/2020'
	group by Diagnosis)m)

/*6)������� ��� �������� �� ������������� ��������.*/
select Diagnosis from Appointment
where ID_P = 1

/*/��������� ������� �������� � ��������, �����������, ������������, �����, ������ � ������� ������������.*/

/*/������� ���� ��������, � ������� ������� �������*/
select Dname from Doctor full outer join Appointment on Doctor.ID_D = Appointment.ID_D
where ID_P = 1

/*/������� ������ ���� ��������� �� �������� ������� ��������� �������� �� ��������� �����*/
select Diagnosis from Appointment full outer join Patient on Patient.ID_P = Appointment.ID_P
where DateOfApp BETWEEN '01/03/2010' AND '27/04/2020' and Patient.Sex = '�'
order by Diagnosis
 
/*/��������� ����� ������ ��������� �� ����*/
select Sex, max(PBirth) as �����_������_����_�������� from Patient
group by Sex


/*������� ���� ��������� � ��������� "�������"*/
select PName from Patient left join Appointment on Patient.ID_P = Appointment.ID_P
where Diagnosis = '�������'

/*������� ���� ��������, ����������� ��������� � ��������*/
select DName from Doctor right join Appointment on Doctor.ID_D = Appointment.ID_D
where Appointment.ID_place = 1 or Appointment.ID_place = 2 or Appointment.ID_place = 3


/*������� ������ ���� �������������� ������, �, ���� ����� ����, ������� ��� �������*/
select Doctors_specialty.Spec_Name, Doctor.Dname from Doctors_specialty left join Doctor on Doctors_specialty.ID_S = Doctor.ID_S

/*/������� ������ ���� ��������, �, ���� ����� ����, ������� ����� ��������, ��� ������� ��� �����������*/
select Medicine.MName, min(ID_A) from List_of_medicine right join Medicine on Medicine.ID_M = List_of_medicine.ID_M group by MName
