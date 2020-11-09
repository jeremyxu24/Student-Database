CREATE TABLE subject(
    subject_id UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v1(),
    subject VARCHAR(75) UNIQUE NOT NULL
)

CREATE TABLE class(
	class_id UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v1(),
	class VARCHAR(75) UNIQUE NOT NULL,
	subject_id UUID, 
	CONSTRAINT fk_subject_class_id
	FOREIGN KEY(subject_id)
	REFERENCES subject(subject_id) ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE teacher (
	teacher_id UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v1(),
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(75)
)

CREATE TABLE class_teacher(
	class_teacher_id UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v1(),
	class_id UUID,
	teacher_id UUID,
	CONSTRAINT fk_classteacher_class_id
	FOREIGN KEY(class_id)
	REFERENCES class(class_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_classteacher_teacher_id
	FOREIGN KEY (teacher_id)
	REFERENCES teacher(teacher_id) ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE student (
	subject_id UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v1(),
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	username VARCHAR(50) NOT NULL,
	password VARCHAR(50) NOT NULL
)
ALTER TABLE student
ADD COLUMN case_carrier_id UUID;
ALTER TABLE student
ADD CONSTRAINT fk_case_carrier_id
FOREIGN KEY (case_carrier_id)
REFERENCES sped_staff(sped_id) ON DELETE CASCADE ON UPDATE CASCADE




CREATE TABLE sped_staff (
	sped_id UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v1(),
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	username VARCHAR(50) NOT NULL,
	password VARCHAR(50) NOT NULL
)

CREATE TABLE sped_schedule (
	teacher_schedule_id  UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v1(),
	period SMALLINT,
	sped_id UUID,
	class_teacher_id UUID,
	CONSTRAINT fk_spedschedule_spedstaff_id
	FOREIGN KEY(sped_id)
	REFERENCES sped_staff(sped_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_spedschedule_classteacher_id
	FOREIGN KEY(class_teacher_id)
	REFERENCES class_teacher(class_teacher_id) ON DELETE CASCADE ON UPDATE CASCADE
)


CREATE TABLE student_schedule (
	student_schedule_id UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v1(),
	student_id UUID,
	period INT,
	class_teacher_id UUID,
	CONSTRAINT fk_studentschedule_student_id
	FOREIGN KEY(student_id)
	REFERENCES student(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_studentschedule_classteacher_id
	FOREIGN KEY(class_teacher_id)
	REFERENCES class_teacher(class_teacher_id) ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE assignment(
	assignment_id UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v1(),
	date DATE DEFAULT(NOW()),
	student_schedule_id UUID,
	sped_id UUID,
	assignment varchar(500),
	complete BOOL DEFAULT FALSE,
	notes varchar(500),
	CONSTRAINT fk_assignments_studentschedule_id
	FOREIGN KEY(student_schedule_id)
	REFERENCES student_schedule(student_schedule_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_assignment_spedstaff_id
	FOREIGN KEY(sped_id)
	REFERENCES sped_staff(sped_id) ON DELETE CASCADE ON UPDATE CASCADE
)
ALTER TABLE assignment
ADD CONSTRAINT fk_assignment_person_id
FOREIGN KEY (person_id)
REFERENCES person(person_id) ON DELETE CASCADE ON UPDATE CASCADE
ALTER TABLE assignment
ADD CONSTRAINT fk_assignment_schedule_id
FOREIGN KEY (schedule_id)
REFERENCES schedule(schedule_id) ON DELETE CASCADE ON UPDATE CASCADE



CREATE TABLE student
(
    student_id UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v1(),
    first_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    last_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    username character varying(50) COLLATE pg_catalog."default" NOT NULL,
    password character varying(50) COLLATE pg_catalog."default" NOT NULL
)


CREATE TABLE accommodation(
	accommodation_id UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v1(),
	accommodation_type VARCHAR(100),
	accommodation VARCHAR(200),
	student_id UUID,
	CONSTRAINT fk_student_accommodation_id
	FOREIGN KEY(student_id)
	REFERENCES student(student_id) ON DELETE CASCADE ON UPDATE CASCADE
)


CREATE TABLE person
(
    person_id uuid NOT NULL DEFAULT uuid_generate_v1(),
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    CONSTRAINT person_pkey PRIMARY KEY (person_id)
)


CREATE TABLE schedule (
	schedule_id UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v1(),
	period INT,
	class_teacher_id UUID,
	person_id UUID,
	CONSTRAINT fk_schedule_person_id
	FOREIGN KEY(person_id)
	REFERENCES person(person_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_schedule_classteacher_id
	FOREIGN KEY(class_teacher_id)
	REFERENCES class_teacher(class_teacher_id) ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE person_user (
	user_id UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v1(),
	username VARCHAR(50) NOT NULL,
	password VARCHAR(50) NOT NULL,
	role VARCHAR(10) NOT NULL
)

ALTER TABLE user_base
ADD CONSTRAINT fk_user_base_person
FOREIGN KEY (person_id)
REFERENCES person(person_id) ON DELETE CASCADE ON UPDATE CASCADE


CREATE TABLE user_base_role (
	user_base_role_id UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v1(),
	app_role_id UUID NOT NULL,
	user_base_id UUID NOT NULL,
	CONSTRAINT fk_userbaserole_userbase
	FOREIGN KEY (user_base_id)
	REFERENCES user_base(user_base_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_userbaserole_approle
	FOREIGN KEY (app_role_id)
	REFERENCES app_role(app_role_id) ON DELETE CASCADE ON UPDATE CASCADE
)
