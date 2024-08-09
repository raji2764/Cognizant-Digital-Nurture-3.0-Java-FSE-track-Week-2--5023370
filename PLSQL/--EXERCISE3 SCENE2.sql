--EXERCISE3 SCENE2  

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus (
    p_department_id IN employees.department_id%TYPE,
    p_bonus_percentage IN NUMBER
)
AS
    v_current_salary employees.salary%TYPE;
    v_new_salary employees.salary%TYPE;
BEGIN
    -- Update the salary of employees in the specified department by adding the bonus percentage
    FOR rec IN (SELECT employee_id, salary 
                FROM employees 
                WHERE department_id = p_department_id
                FOR UPDATE) LOOP
        
        v_current_salary := rec.salary;
        v_new_salary := v_current_salary + (v_current_salary * p_bonus_percentage / 100);

        -- Update the employee's salary with the new amount
        UPDATE employees
        SET salary = v_new_salary
        WHERE employee_id = rec.employee_id;
    END LOOP;

    -- Commit the transaction
    COMMIT;

    -- Log success message
    DBMS_OUTPUT.PUT_LINE('Bonus updated successfully for all employees in department ' || p_department_id || '.');
EXCEPTION
    WHEN OTHERS THEN
        -- Handle all other exceptions
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM || '. Bonus update failed.');
        ROLLBACK;
END UpdateEmployeeBonus;
/
