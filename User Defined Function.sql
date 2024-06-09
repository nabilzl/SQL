USE employees;
DROP FUNCTION IF EXISTS f_emp_avg_salary;

DELIMITER $$
CREATE FUNCTION f_emp_avg_salary(p_emp_no INTEGER) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE v_avg_salary DECIMAL(10,2);
    
    SELECT AVG(s.salary) INTO v_avg_salary
    FROM employees e
    JOIN salaries s ON e.emp_no = s.emp_no
    WHERE e.emp_no = p_emp_no;
    
    RETURN v_avg_salary;
END$$
DELIMITER ;

SELECT f_emp_avg_salary(11300);

DROP FUNCTION IF EXISTS emp_info;

DELIMITER $$
CREATE FUNCTION emp_info(p_fname VARCHAR(255), p_lname VARCHAR(255)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE v_salary DECIMAL(10,2);
    DECLARE v_max_from_date DATE;
    
SELECT 
    MAX(from_date)
INTO v_max_from_date FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_fname
        AND e.last_name = p_lname;
        
SELECT 
    s.salary
INTO v_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_fname
        AND e.last_name = p_lname
        AND s.from_date = v_max_from_date;
    
    RETURN v_salary;
END$$
DELIMITER ;

SELECT emp_info('Aruna','Journel');

DROP FUNCTION IF EXISTS emp_info2;

DELIMITER $$
CREATE FUNCTION emp_info2(p_fname VARCHAR(255), p_lname VARCHAR(255)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE v_salary DECIMAL(10,2);
    
SELECT 
    s.salary
INTO v_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_fname
        AND e.last_name = p_lname
        AND s.from_date = (SELECT 
            MAX(from_date)
        FROM
            employees e
                JOIN
            salaries s ON e.emp_no = s.emp_no
        WHERE
            e.first_name = p_fname
                AND e.last_name = p_lname);
	
    RETURN v_salary;
END$$
DELIMITER ;

SELECT emp_info2('Aruna','Journel');


SET @v_emp_no = 11300;
SELECT 
    emp_no,
    first_name,
    last_name,
    F_EMP_AVG_SALARY(@v_emp_no) AS avg_salary
FROM
    employees
WHERE
    emp_no = @v_emp_no;