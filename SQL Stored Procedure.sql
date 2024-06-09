USE employees;
DROP PROCEDURE IF EXISTS emp_info;

DELIMITER $$
CREATE PROCEDURE emp_info(IN p_fname VARCHAR(50), IN p_lname VARCHAR(50), OUT p_emp_no INTEGER)
BEGIN
	SELECT e.emp_no INTO p_emp_no
    FROM employees e
    WHERE e.first_name = p_fname AND e.last_name = p_lname;
END$$
DELIMITER ;