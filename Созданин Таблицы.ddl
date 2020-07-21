
CREATE TABLE Appointment
( 
	Diagnosis            varchar(70)  NULL ,
	DateOfApp            datetime  NULL ,
	Symptoms             varchar(70)  NULL ,
	Prescriptions        varchar(70)  NULL ,
	ID_P                 integer  NOT NULL ,
	ID_place             integer  NOT NULL ,
	ID_A                 integer  NOT NULL ,
	ID_D				 integer  NULL 
)
go



ALTER TABLE Appointment
	ADD CONSTRAINT XPKПрием PRIMARY KEY  CLUSTERED (ID_A ASC)
go



CREATE TABLE Appointment_place
( 
	ID_Place             integer  NOT NULL ,
	PlaceName            varchar(70)  NULL ,
	IsClinic			 boolean  NOT NULL
)
go



ALTER TABLE Appointment_place
	ADD CONSTRAINT XPKМесто_приема PRIMARY KEY  CLUSTERED (ID_Place ASC)
go



CREATE TABLE Doctor
( 
	ID_D                 integer  NOT NULL ,
	DName                varchar(70)  NULL ,
	ID_S                 integer  NULL 
)
go



ALTER TABLE Doctor
	ADD CONSTRAINT XPKВрач PRIMARY KEY  CLUSTERED (ID_D ASC)
go



CREATE TABLE Doctors_specialty
( 
	ID_S                 integer  NOT NULL ,
	Spec_Name            varchar(70)  NULL 
)
go



ALTER TABLE Doctors_specialty
	ADD CONSTRAINT XPKСпециальность_врача PRIMARY KEY  CLUSTERED (ID_S ASC)
go



CREATE TABLE List_of_medicine
( 
	ID_A                 integer  NOT NULL ,
	ID_M                 integer  NOT NULL 
)
go



ALTER TABLE List_of_medicine
	ADD CONSTRAINT XPKList_of_medecinies PRIMARY KEY  CLUSTERED (ID_A ASC,ID_M ASC)
go



CREATE TABLE Medicine
( 
	ID_M                 integer  NOT NULL ,
	HowToApply           varchar(70)  NULL ,
	Action               varchar(70)  NULL ,
	SideEffects          varchar(70)  NULL ,
	MName                varchar(70)  NULL 
)
go



ALTER TABLE Medicine
	ADD CONSTRAINT XPKЛекарство PRIMARY KEY  CLUSTERED (ID_M ASC)
go



CREATE TABLE Patient
( 
	ID_P                 integer  NOT NULL ,
	PName                varchar(70)  NULL ,
	PBirth               datetime  NULL ,
	PAdress              varchar(70)  NULL ,
	Sex                  varchar(70)  NULL 
)
go



ALTER TABLE Patient
	ADD CONSTRAINT XPKПациент PRIMARY KEY  CLUSTERED (ID_P ASC)
go




ALTER TABLE Appointment
	ADD CONSTRAINT R_13 FOREIGN KEY (ID_P) REFERENCES Patient(ID_P)
		ON DELETE CASCADE
		ON UPDATE CASCADE
go




ALTER TABLE Appointment
	ADD CONSTRAINT R_16 FOREIGN KEY (ID_place) REFERENCES Appointment_place(ID_Place)
		ON DELETE CASCADE
		ON UPDATE CASCADE
go




ALTER TABLE Appointment
	ADD CONSTRAINT R_17 FOREIGN KEY (ID_doctor) REFERENCES Doctor(ID_D)
		ON DELETE CASCADE
		ON UPDATE CASCADE
go




ALTER TABLE Doctor
	ADD CONSTRAINT R_33 FOREIGN KEY (ID_S) REFERENCES Doctors_specialty(ID_S)
		ON DELETE CASCADE
		ON UPDATE CASCADE
go




ALTER TABLE List_of_medicine
	ADD CONSTRAINT R_35 FOREIGN KEY (ID_A) REFERENCES Appointment(ID_A)
		ON DELETE CASCADE
		ON UPDATE CASCADE
go




ALTER TABLE List_of_medicine
	ADD CONSTRAINT R_36 FOREIGN KEY (ID_M) REFERENCES Medicine(ID_M)
		ON DELETE CASCADE
		ON UPDATE CASCADE
go




CREATE TRIGGER tD_Appointment ON Appointment FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Appointment */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Appointment  List_of_medicine on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00047798", PARENT_OWNER="", PARENT_TABLE="Appointment"
    CHILD_OWNER="", CHILD_TABLE="List_of_medicine"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_35", FK_COLUMNS="ID_A" */
    IF EXISTS (
      SELECT * FROM deleted,List_of_medicine
      WHERE
        /*  %JoinFKPK(List_of_medicine,deleted," = "," AND") */
        List_of_medicine.ID_A = deleted.ID_A
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Appointment because List_of_medicine exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Patient  Appointment on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Patient"
    CHILD_OWNER="", CHILD_TABLE="Appointment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="ID_P" */
    IF EXISTS (SELECT * FROM deleted,Patient
      WHERE
        /* %JoinFKPK(deleted,Patient," = "," AND") */
        deleted.ID_P = Patient.ID_P AND
        NOT EXISTS (
          SELECT * FROM Appointment
          WHERE
            /* %JoinFKPK(Appointment,Patient," = "," AND") */
            Appointment.ID_P = Patient.ID_P
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Appointment because Patient exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Appointment_place  Appointment on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Appointment_place"
    CHILD_OWNER="", CHILD_TABLE="Appointment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="ID_place" */
    IF EXISTS (SELECT * FROM deleted,Appointment_place
      WHERE
        /* %JoinFKPK(deleted,Appointment_place," = "," AND") */
        deleted.ID_place = Appointment_place.ID_Place AND
        NOT EXISTS (
          SELECT * FROM Appointment
          WHERE
            /* %JoinFKPK(Appointment,Appointment_place," = "," AND") */
            Appointment.ID_place = Appointment_place.ID_Place
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Appointment because Appointment_place exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Doctor  Appointment on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Doctor"
    CHILD_OWNER="", CHILD_TABLE="Appointment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="ID_doctor" */
    IF EXISTS (SELECT * FROM deleted,Doctor
      WHERE
        /* %JoinFKPK(deleted,Doctor," = "," AND") */
        deleted.ID_doctor = Doctor.ID_D AND
        NOT EXISTS (
          SELECT * FROM Appointment
          WHERE
            /* %JoinFKPK(Appointment,Doctor," = "," AND") */
            Appointment.ID_doctor = Doctor.ID_D
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Appointment because Doctor exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Appointment ON Appointment FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Appointment */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insID_A integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Appointment  List_of_medicine on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="000512aa", PARENT_OWNER="", PARENT_TABLE="Appointment"
    CHILD_OWNER="", CHILD_TABLE="List_of_medicine"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_35", FK_COLUMNS="ID_A" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ID_A)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,List_of_medicine
      WHERE
        /*  %JoinFKPK(List_of_medicine,deleted," = "," AND") */
        List_of_medicine.ID_A = deleted.ID_A
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Appointment because List_of_medicine exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Patient  Appointment on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Patient"
    CHILD_OWNER="", CHILD_TABLE="Appointment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="ID_P" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ID_P)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Patient
        WHERE
          /* %JoinFKPK(inserted,Patient) */
          inserted.ID_P = Patient.ID_P
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Appointment because Patient does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Appointment_place  Appointment on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Appointment_place"
    CHILD_OWNER="", CHILD_TABLE="Appointment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="ID_place" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ID_place)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Appointment_place
        WHERE
          /* %JoinFKPK(inserted,Appointment_place) */
          inserted.ID_place = Appointment_place.ID_Place
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Appointment because Appointment_place does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Doctor  Appointment on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Doctor"
    CHILD_OWNER="", CHILD_TABLE="Appointment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="ID_doctor" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ID_doctor)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Doctor
        WHERE
          /* %JoinFKPK(inserted,Doctor) */
          inserted.ID_doctor = Doctor.ID_D
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.ID_doctor IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Appointment because Doctor does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_Appointment_place ON Appointment_place FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Appointment_place */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Appointment_place  Appointment on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00010678", PARENT_OWNER="", PARENT_TABLE="Appointment_place"
    CHILD_OWNER="", CHILD_TABLE="Appointment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="ID_place" */
    IF EXISTS (
      SELECT * FROM deleted,Appointment
      WHERE
        /*  %JoinFKPK(Appointment,deleted," = "," AND") */
        Appointment.ID_place = deleted.ID_Place
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Appointment_place because Appointment exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Appointment_place ON Appointment_place FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Appointment_place */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insID_Place integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Appointment_place  Appointment on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00011783", PARENT_OWNER="", PARENT_TABLE="Appointment_place"
    CHILD_OWNER="", CHILD_TABLE="Appointment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="ID_place" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ID_Place)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Appointment
      WHERE
        /*  %JoinFKPK(Appointment,deleted," = "," AND") */
        Appointment.ID_place = deleted.ID_Place
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Appointment_place because Appointment exists.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_Doctor ON Doctor FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Doctor */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Doctor  Appointment on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000215ab", PARENT_OWNER="", PARENT_TABLE="Doctor"
    CHILD_OWNER="", CHILD_TABLE="Appointment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="ID_doctor" */
    IF EXISTS (
      SELECT * FROM deleted,Appointment
      WHERE
        /*  %JoinFKPK(Appointment,deleted," = "," AND") */
        Appointment.ID_doctor = deleted.ID_D
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Doctor because Appointment exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Doctors_specialty  Doctor on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Doctors_specialty"
    CHILD_OWNER="", CHILD_TABLE="Doctor"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_33", FK_COLUMNS="ID_S" */
    IF EXISTS (SELECT * FROM deleted,Doctors_specialty
      WHERE
        /* %JoinFKPK(deleted,Doctors_specialty," = "," AND") */
        deleted.ID_S = Doctors_specialty.ID_S AND
        NOT EXISTS (
          SELECT * FROM Doctor
          WHERE
            /* %JoinFKPK(Doctor,Doctors_specialty," = "," AND") */
            Doctor.ID_S = Doctors_specialty.ID_S
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Doctor because Doctors_specialty exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Doctor ON Doctor FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Doctor */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insID_D integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Doctor  Appointment on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00028538", PARENT_OWNER="", PARENT_TABLE="Doctor"
    CHILD_OWNER="", CHILD_TABLE="Appointment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="ID_doctor" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ID_D)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Appointment
      WHERE
        /*  %JoinFKPK(Appointment,deleted," = "," AND") */
        Appointment.ID_doctor = deleted.ID_D
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Doctor because Appointment exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Doctors_specialty  Doctor on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Doctors_specialty"
    CHILD_OWNER="", CHILD_TABLE="Doctor"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_33", FK_COLUMNS="ID_S" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ID_S)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Doctors_specialty
        WHERE
          /* %JoinFKPK(inserted,Doctors_specialty) */
          inserted.ID_S = Doctors_specialty.ID_S
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.ID_S IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Doctor because Doctors_specialty does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_Doctors_specialty ON Doctors_specialty FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Doctors_specialty */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Doctors_specialty  Doctor on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0000e55f", PARENT_OWNER="", PARENT_TABLE="Doctors_specialty"
    CHILD_OWNER="", CHILD_TABLE="Doctor"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_33", FK_COLUMNS="ID_S" */
    IF EXISTS (
      SELECT * FROM deleted,Doctor
      WHERE
        /*  %JoinFKPK(Doctor,deleted," = "," AND") */
        Doctor.ID_S = deleted.ID_S
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Doctors_specialty because Doctor exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Doctors_specialty ON Doctors_specialty FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Doctors_specialty */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insID_S integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Doctors_specialty  Doctor on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0000fb94", PARENT_OWNER="", PARENT_TABLE="Doctors_specialty"
    CHILD_OWNER="", CHILD_TABLE="Doctor"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_33", FK_COLUMNS="ID_S" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ID_S)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Doctor
      WHERE
        /*  %JoinFKPK(Doctor,deleted," = "," AND") */
        Doctor.ID_S = deleted.ID_S
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Doctors_specialty because Doctor exists.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_List_of_medicine ON List_of_medicine FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on List_of_medicine */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Appointment  List_of_medicine on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="000260be", PARENT_OWNER="", PARENT_TABLE="Appointment"
    CHILD_OWNER="", CHILD_TABLE="List_of_medicine"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_35", FK_COLUMNS="ID_A" */
    IF EXISTS (SELECT * FROM deleted,Appointment
      WHERE
        /* %JoinFKPK(deleted,Appointment," = "," AND") */
        deleted.ID_A = Appointment.ID_A AND
        NOT EXISTS (
          SELECT * FROM List_of_medicine
          WHERE
            /* %JoinFKPK(List_of_medicine,Appointment," = "," AND") */
            List_of_medicine.ID_A = Appointment.ID_A
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last List_of_medicine because Appointment exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Medicine  List_of_medicine on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Medicine"
    CHILD_OWNER="", CHILD_TABLE="List_of_medicine"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_36", FK_COLUMNS="ID_M" */
    IF EXISTS (SELECT * FROM deleted,Medicine
      WHERE
        /* %JoinFKPK(deleted,Medicine," = "," AND") */
        deleted.ID_M = Medicine.ID_M AND
        NOT EXISTS (
          SELECT * FROM List_of_medicine
          WHERE
            /* %JoinFKPK(List_of_medicine,Medicine," = "," AND") */
            List_of_medicine.ID_M = Medicine.ID_M
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last List_of_medicine because Medicine exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_List_of_medicine ON List_of_medicine FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on List_of_medicine */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insID_A integer, 
           @insID_M integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Appointment  List_of_medicine on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00029222", PARENT_OWNER="", PARENT_TABLE="Appointment"
    CHILD_OWNER="", CHILD_TABLE="List_of_medicine"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_35", FK_COLUMNS="ID_A" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ID_A)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Appointment
        WHERE
          /* %JoinFKPK(inserted,Appointment) */
          inserted.ID_A = Appointment.ID_A
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update List_of_medicine because Appointment does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Medicine  List_of_medicine on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Medicine"
    CHILD_OWNER="", CHILD_TABLE="List_of_medicine"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_36", FK_COLUMNS="ID_M" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ID_M)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Medicine
        WHERE
          /* %JoinFKPK(inserted,Medicine) */
          inserted.ID_M = Medicine.ID_M
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update List_of_medicine because Medicine does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_Medicine ON Medicine FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Medicine */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Medicine  List_of_medicine on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0001033e", PARENT_OWNER="", PARENT_TABLE="Medicine"
    CHILD_OWNER="", CHILD_TABLE="List_of_medicine"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_36", FK_COLUMNS="ID_M" */
    IF EXISTS (
      SELECT * FROM deleted,List_of_medicine
      WHERE
        /*  %JoinFKPK(List_of_medicine,deleted," = "," AND") */
        List_of_medicine.ID_M = deleted.ID_M
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Medicine because List_of_medicine exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Medicine ON Medicine FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Medicine */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insID_M integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Medicine  List_of_medicine on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0001101e", PARENT_OWNER="", PARENT_TABLE="Medicine"
    CHILD_OWNER="", CHILD_TABLE="List_of_medicine"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_36", FK_COLUMNS="ID_M" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ID_M)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,List_of_medicine
      WHERE
        /*  %JoinFKPK(List_of_medicine,deleted," = "," AND") */
        List_of_medicine.ID_M = deleted.ID_M
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Medicine because List_of_medicine exists.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_Patient ON Patient FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Patient */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Patient  Appointment on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0000f294", PARENT_OWNER="", PARENT_TABLE="Patient"
    CHILD_OWNER="", CHILD_TABLE="Appointment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="ID_P" */
    IF EXISTS (
      SELECT * FROM deleted,Appointment
      WHERE
        /*  %JoinFKPK(Appointment,deleted," = "," AND") */
        Appointment.ID_P = deleted.ID_P
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Patient because Appointment exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Patient ON Patient FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Patient */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insID_P integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Patient  Appointment on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="000105a6", PARENT_OWNER="", PARENT_TABLE="Patient"
    CHILD_OWNER="", CHILD_TABLE="Appointment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="ID_P" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ID_P)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Appointment
      WHERE
        /*  %JoinFKPK(Appointment,deleted," = "," AND") */
        Appointment.ID_P = deleted.ID_P
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Patient because Appointment exists.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


