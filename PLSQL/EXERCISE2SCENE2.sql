CREATE OR REPLACE PROCEDURE UpdateSalary (
    p_employee_id IN employees.employee_id%TYPE,
    p_percentage IN NUMBER
)
AS
    v_salary employees.salary%TYPE;
    e_employee_not_found EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_employee_not_found, -01403); -- ORA-01403: no data found
BEGIN
    -- Get the current salary of the employee
    SELECT salary INTO v_salary
    FROM employees
    WHERE employee_id = p_employee_id;

    -- Update the salary
    UPDATE employees
    SET salary = salary + (salary * p_percentage / 100)
    WHERE employee_id = p_employee_id;

    -- Commit the transaction
    COMMIT;

    -- Log success message
    DBMS_OUTPUT.PUT_LINE('Salary of employee ' || p_employee_id || ' increased by ' || p_percentage || '%.');
EXCEPTION
    WHEN e_employee_not_found THEN
        -- Handle employee not found error
        DBMS_OUTPUT.PUT_LINE('Error: Employee ID ' || p_employee_id || ' does not exist. Update failed.');
    WHEN OTHERS THEN
        -- Handle all other exceptions
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM || '. Update failed.');
        ROLLBACK;
END UpdateSalary;
/
