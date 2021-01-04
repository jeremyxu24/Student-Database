-- STUDENT SCHEDULE
CREATE PROCEDURE 
	select_student_schedule(p_student_id INT)
	LANGUAGE SQL
	AS $$
		SELECT
			ss.period
			,t.last_name
			,c.class
		FROM
			student s 
		LEFT JOIN
			student_schedule ss on ss.student_id=s.student_id
		LEFT JOIN
			class_teacher ct on ct.class_teacher_id=ss.class_teacher_id
		LEFT JOIN
			class c on c.class_id=ct.class_id
		LEFT JOIN
			teacher t on t.teacher_id=ct.teacher_id
		WHERE 
			s.student_id=p_student_id
	$$

CREATE PROCEDURE 
	insert_student_schedule(p_student_id INT, 
		p_period INT)
	LANGUAGE SQL
	AS $$
		INSERT INTO 
			student_schedule(student_id,period)
		VALUES
			(p_student_id, p_period);
	$$

CREATE PROCEDURE 
	update_student_schedule
		(p_student_id INT, 
		 p_period INT, 
		 p_class VARCHAR(50), 
		 p_last_name VARCHAR(50), 
		 p_first_name VARCHAR(50))
	LANGUAGE SQL
	AS $$
		UPDATE 
			student_schedule ss
		SET class_teacher_id= 
			(SELECT 
			 	class_teacher_id 
			 FROM 
			 	class_teacher ct
			 LEFT JOIN 
			 	class c on      c.class_id=ct.class_id
			 LEFT JOIN 
			 	teacher t on t.teacher_id=ct.teacher_id
			 WHERE 
			 	t.first_name=p_first_name AND 
			 	t.last_name=p_last_name AND 
			 	c.class=p_class)
		WHERE 
			ss.student_id=p_student_id AND 
			ss.period=p_period
	$$

CREATE PROCEDURE 
	delete_student_schedule
		(p_student_id INT, 
		 p_period INT)
	LANGUAGE SQL
	AS $$
		DELETE FROM 
			student_schedule
		WHERE 
			student_id=p_student_id AND 
			period=p_period
$$




--SPED SCHEDULE
CREATE PROCEDURE 
	select_sped
		(s_sped_id INT)
	LANGUAGE SQL
	AS $$
		SELECT
			ss2.period,
			t.last_name,
			c.class
		FROM
			sped_staff ss1
		LEFT JOIN
			sped_schedule ss2 on ss1.sped_id=ss2.sped_id
		LEFT JOIN
			class_teacher ct on ct.class_teacher_id=ss2.class_teacher_id
		LEFT JOIN
			class c on c.class_id=ct.class_id
		LEFT JOIN
			teacher t on t.teacher_id=ct.teacher_id
		WHERE
			ss2.sped_id=s_sped_id
$$

CREATE PROCEDURE 
	select_sped_class_student
		(s_sped_schedule_id INT)
	LANGUAGE SQL
	AS $$
		SELECT
			s.first_name,
			s.last_name
		FROM
			sped_staff ss1
		LEFT JOIN
			sped_schedule ss2 on ss1.sped_id=ss2.sped_id
		LEFT JOIN
			class_teacher ct on ct.class_teacher_id=ss2.class_teacher_id
		LEFT JOIN
			class c on c.class_id=ct.class_id
		LEFT JOIN
			teacher t on t.teacher_id=ct.teacher_id
		LEFT JOIN
			student_schedule ss3 on ss3.class_teacher_id=ct.class_teacher_id
		LEFT JOIN
			student s on s.student_id=ss3.student_id
		WHERE
			sped_schedule_id=s_sped_schedule_id
$$

CREATE PROCEDURE 
	insert_sped_schedule
		(p_sped_id INT, 
		 p_period INT)
	LANGUAGE SQL
	AS $$
		INSERT INTO 
			sped_schedule
				(sped_id,
				 period)
		VALUES
			(p_sped_id, 
			 p_period)
	$$

CREATE PROCEDURE 
	update_sped_schedule(s_id INT, per INT, cl VARCHAR(50), ln VARCHAR(50), fn VARCHAR(50))
LANGUAGE SQL
AS $$
UPDATE sped_schedule ss
	SET class_teacher_id= 
		(select class_teacher_id from class_teacher ct
		LEFT JOIN class c on c.class_id=ct.class_id
		LEFT JOIN teacher t on t.teacher_id=ct.teacher_id
		WHERE t.first_name=fn AND t.last_name=ln AND c.class=cl)
	WHERE ss.sped_id=s_id AND ss.period=per
$$

CREATE PROCEDURE 
	delete_sped_schedule(s_id INT, per INT)
LANGUAGE SQL
AS $$
	DELETE FROM sped_schedule
	WHERE sped_id=s_id AND period=per
$$

-- CLASS

CREATE PROCEDURE 
	select_class()
	LANGUAGE SQL
	AS $$
		SELECT 
			class, s.subject
		FROM
			class c
		LEFT JOIN
			subject s on s.subject_id=c.subject_id 
	$$

CREATE PROCEDURE 
	insert_class
		(p_class VARCHAR(50), 
		 p_subject VARCHAR(50))
	LANGUAGE SQL
	AS $$
		INSERT INTO 
			class
				(class, 
				 subject_id)
		VALUES
			(p_class, 
			(SELECT 
				subject_id 
			 FROM 
				subject 
			 WHERE 
				subject=p_subject));
	$$

CREATE PROCEDURE
	update_class
		(p_class_id INT,
		p_class VARCHAR(50),
		p_subject VARCHAR(50))
	LANGUAGE SQL
	AS $$ 
		UPDATE
			class
		SET 
			class=p_class,
			subject_id=(SElECT 
				subject_id 
				FROM 
					subject 
				WHERE 
					subject=p_subject)
		WHERE 
			class_id=p_class_id
	$$

CREATE PROCEDURE 
	delete_class
		(p_class_id INT)
	LANGUAGE SQL
	AS $$
		DELETE FROM 
			class
		WHERE 
			class_id=p_class_id
	$$


-- TEACHER
CREATE PROCEDURE 
	select_teacher()
	LANGUAGE SQL
	AS $$
		SELECT 
			first_name,
			last_name,
			email
		FROM
			teacher
	$$

CREATE PROCEDURE 
	insert_teacher
		(p_first_name VARCHAR(50), 
		 p_last_name VARCHAR(50), 
		 p_email VARCHAR(50))
	LANGUAGE SQL
	AS $$
		INSERT INTO 
			teacher
				(first_name, 
				 last_name, 
				 email)
		VALUES
			(p_first_name, 
			 p_last_name, 
			 p_email)
	$$

CREATE PROCEDURE
	update_teacher
		(p_teacher_id INT,
		p_first_name VARCHAR(50),
		p_last_name VARCHAR(50),
		p_email VARCHAR(50))
	LANGUAGE SQL
	AS $$
		UPDATE 
			teacher
		SET 
			first_name=p_first_name,
			last_name=p_last_name,
			email=p_email
		WHERE 
			teacher_id=p_teacher_id
	$$

CREATE PROCEDURE 
	delete_teacher
		(p_teacher_id INT)
	LANGUAGE SQL
	AS $$
		DELETE FROM 
			teacher
		WHERE 
			teacher_id=p_teacher_id
	$$

-- CLASS TEACHER
CREATE PROCEDURE
	select_class_teacher()
	LANGUAGE SQL
	AS $$
		SELECT
			first_name,
			last_name,
			email
		FROM 
			teacher
	$$

CREATE PROCEDURE
	insert_class_teacher(
		p_class_id INT,
		p_teacher_id INT)
	LANGUAGE SQL

	AS $$
		INSERT INTO
			class_teacher
				(class_id,
				teacher_id)
		VALUES
			(p_class_id,
			p_teacher_id)
	$$

CREATE PROCEDURE
	update_class_teacher(
		p_class_teacher_id INT,
		p_class_id INT,
		p_teacher_id INT)
	LANGUAGE SQL

	AS $$
		UPDATE
			class_teacher
		SET
			class_id=p_class_id,
			teacher_id=p_teacher_id
		WHERE 
			class_teacher_id=p_class_teacher_id
	$$

CREATE PROCEDURE
	delete_class_teacher
		(p_class_teacher_id INT)
	LANGUAGE SQL
	AS $$
		DELETE FROM
			class_teacher
		WHERE 
			class_teacher_id=p_class_teacher_id
	$$


-- STUDENT


CREATE PROCEDURE 
	insert_student(fn VARCHAR(50), ln VARCHAR(50), un VARCHAR(30), pw VARCHAR(30))
LANGUAGE SQL
AS $$
	INSERT INTO 
		student(first_name, last_name, username, password)
	VALUES
		(fn, ln, un, pw)
$$

CREATE PROCEDURE 
	update_student(s_id INT, fn VARCHAR(50), ln VARCHAR(50), un VARCHAR(30), pw VARCHAR(30))
LANGUAGE SQL
AS $$
	UPDATE
		student
	SET
		first_name = fn
		,last_name = ln
		,username = un
		,password = pw
	WHERE 
		student_id=s_id;
$$

CREATE PROCEDURE 
	delete_student(s_id INT)
LANGUAGE SQL
AS $$
	DELETE FROM student
	WHERE student_id=s_id
$$

-- SPED STAFF
CREATE PROCEDURE 
	select_sped_all()
LANGUAGE SQL
AS $$
	SELECT
		first_name
		,last_name
	FROM
		sped_staff
$$


CREATE PROCEDURE 
	insert_sped(fn VARCHAR(50), ln VARCHAR(50), un VARCHAR(30), pw VARCHAR(30))
LANGUAGE SQL
AS $$
	INSERT INTO 
		sped_staff(first_name, last_name, username, password)
	VALUES
		(fn, ln, un, pw)
$$

CREATE PROCEDURE 
	update_sped_staff(s_id INT, fn VARCHAR(50), ln VARCHAR(50), un VARCHAR(30), pw VARCHAR(30))
LANGUAGE SQL
AS $$
	UPDATE
		sped_staff
	SET
		first_name = fn
		,last_name = ln
		,username = un
		,password = pw
	WHERE 
		sped_id=s_id;
$$

CREATE PROCEDURE 
	delete_sped(s_id INT)
LANGUAGE SQL
AS $$
	DELETE FROM sped_staff
	WHERE sped_id=s_id
$$

-- ASSIGNMENTS (STUDENTS VIEW)
CREATE PROCEDURE
	select_missing_assignment_sv(s_id INT)
LANGUAGE SQL
AS $$
	SELECT 
		a.date
		,ss.period
		,c.class
		,t.last_name
		,a.missing_assignment
	FROM 
		missing_assignment a
	LEFT JOIN
		student_schedule ss on ss.student_schedule_id=a.student_schedule_id
	LEFT JOIN
		class_teacher ct on ct.class_teacher_id=ss.class_teacher_id
	LEFT JOIN 
		teacher t on t.teacher_id=ct.teacher_id
	LEFT JOIN 
		class c on c.class_id=ct.class_id
	WHERE
		ss.student_id=s_id
	ORDER BY
		a.date
$$

CREATE PROCEDURE
	update_missing_assignment_sv1(asgmt_id INT)
LANGUAGE SQL
AS $$
	UPDATE missing_assignment
	SET complete = 'True'
	WHERE
		missing_assignment_id = asgmt_id
$$

CREATE PROCEDURE
	update_missing_assignment_sv2(asgmt_id INT)
LANGUAGE SQL
AS $$
	UPDATE assignment
	SET complete = 'False'
	WHERE
		missing_assignment_id = asgmt_id
$$

-- ASSIGMENTS (TEACHER VIEW)
CREATE PROCEDURE 
	select_missing_assignment_tv(s_id INT)
LANGUAGE SQL
AS $$
	SELECT 
		a.date
		,ss1.period
		,c.class
		,t.last_name
		,ss2.first_name
		,a.missing_assignment
		,a.notes		
	FROM 
		missing_assignment a
	LEFT JOIN
		student_schedule ss1 on ss1.student_schedule_id=a.student_schedule_id
	LEFT JOIN
		class_teacher ct on ct.class_teacher_id=ss1.class_teacher_id
	LEFT JOIN 
		teacher t on t.teacher_id=ct.teacher_id
	LEFT JOIN 
		class c on c.class_id=ct.class_id
	LEFT JOIN
		sped_staff ss2 on ss2.sped_id=a.sped_id
	WHERE
		ss1.student_id=s_id
	ORDER BY
		a.date
$$

CREATE PROCEDURE 
	insert_missing_assignment(
		p_student_id INT, 
		p_period INT, 
		cl VARCHAR(50), 
		ln VARCHAR(50), sp_id INT, asgmt VARCHAR(500), notes VARCHAR(500))
LANGUAGE SQL
AS $$
	INSERT INTO 
		missing_assignment(sped_id, assignment,notes)
	VALUES
		(sp_id, asgmt,notes);
	UPDATE missing_assignment ss
	SET student_schedule_id= 
		(SELECT
			ss.student_schedule_id
			FROM 
				student_schedule ss
			LEFT JOIN
				class_teacher ct on ct.class_teacher_id=ss.class_teacher_id
			LEFT JOIN
				teacher t on t.teacher_id=ct.teacher_id
			LEFT JOIN
				class c on c.class_id=ct.class_id
			WHERE
				ss.student_id=s_id AND ss.period=per
		)
	WHERE missing_assignment=asgmt
$$	



CREATE PROCEDURE 
	delete_assignment(s_id INT)
LANGUAGE SQL
AS $$
	DELETE FROM
		assignment a
	USING 
		student_schedule as ss
		,student as s
	WHERE 
		(ss.student_schedule_id=a.student_schedule_id) AND 
		(s.student_id=ss.student_id) AND 
		s.student_id=s_id
$$

-- DIRECTED STUDIES
CREATE PROCEDURE 
	select_directed(per INT)
LANGUAGE SQL
AS $$
	SELECT
		s.first_name
		,s.last_name
	FROM
		student s
	left join 
		student_schedule ss on s.student_id=ss.student_id
	LEFT JOIN
		class_teacher ct on ct.class_teacher_id=ss.class_teacher_id
	LEFT JOIN
		class c on c.class_id=ct.class_id
	WHERE 
		c.class='Directed Studies' AND ss.period=per
$$
	
									     
