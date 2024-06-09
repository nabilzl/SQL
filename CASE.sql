USE employees;

SELECT 
    emp_no,
    first_name,
    last_name,
    CASE
        WHEN gender = 'M' THEN 'Male'
        ELSE 'Female'
    END AS gender
FROM
    employees;
    
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employees'
    END AS is_manager
FROM
    employees e
        LEFT JOIN
    dept_manager dm ON dm.emp_no = e.emp_no
WHERE
    e.emp_no > 109990;
    
# IF statement can only has one condition
    
SELECT 
    emp_no,
    first_name,
    last_name,
    IF(gender = 'M', 'Male', 'Female') AS gender
FROM
    employees;

# CASE can include multiple conditions
SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more than $30,000'
        WHEN MAX(s.salary) - MIN(s.salary) BETWEEN 20000 AND 30000 THEN 'Salary was raised by more than $20,000 but less than $30,000'
        ELSE 'Salary was raised by less than $20,000'
    END AS salary_increase
FROM
    dept_manager dm
        JOIN
    employees e ON e.emp_no = dm.emp_no
        JOIN
    salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no;

# Check either employees or manager
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
    END AS is_manager
FROM
    employees e
        LEFT JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
WHERE
    e.emp_no > 109990;
    
# Find whose salary more than #30,000 or less than $30,000

# Method 1 - use CASE
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary increase more than $30,000'
        ELSE 'Salary increase less than $30,000'
    END AS salary_increase
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
        JOIN
    salaries s ON dm.emp_no = s.emp_no
GROUP BY s.emp_no;

# Method 2 - use if
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    IF(MAX(s.salary) - MIN(s.salary) > 30000,
        'Salary increase more than $30,000',
        'Salary increase less than $30,000') AS salary_increase
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
        JOIN
    salaries s ON dm.emp_no = s.emp_no
GROUP BY s.emp_no;


# Find employees who are still employed and not employed
# Method 1
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN de.to_date = '9999-01-01' THEN 'Is still employed'
        ELSE 'Is not employee anymore'
    END AS current_employee
FROM
    employees e
        LEFT JOIN
    dept_emp de ON e.emp_no = de.emp_no
GROUP BY e.emp_no , de.dept_no
LIMIT 100;

# Method 2
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    de.to_date,
    CASE
        WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employed'
        ELSE 'Is not employee anymore'
    END AS current_employee
FROM
    employees e
        LEFT JOIN
    dept_emp de ON e.emp_no = de.emp_no
GROUP BY e.emp_no , de.dept_no
LIMIT 100;