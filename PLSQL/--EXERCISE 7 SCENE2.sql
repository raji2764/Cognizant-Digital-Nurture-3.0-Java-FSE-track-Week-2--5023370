--EXERCISE 7 SCENE2
-- Package Specification
CREATE OR REPLACE PACKAGE EmployeeManagement AS
    -- Procedure to hire new employees
    PROCEDURE HireNewEmployee(p_employee_id IN NUMBER, p_name IN VARCHAR2, p_salary IN NUMBER);
    
    -- Procedure to update employee details
    PROCEDURE UpdateEmployeeDetails(p_employee_id IN NUMBER, p_name IN VARCHAR2, p_salary IN NUMBER);
    
    -- Function to calculate annual salary
    FUNCTION CalculateAnnualSalary(p_employee_id IN NUMBER) RETURN NUMBER;
END EmployeeManagement;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY EmployeeManagement AS

    PROCEDURE HireNewEmployee(p_employee_id IN NUMBER, p_name IN VARCHAR2, p_salary IN NUMBER) IS
    BEGIN
        INSERT INTO Employees (employee_id, name, salary)
        VALUES (p_employee_id, p_name, p_salary);
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Employee ID already exists.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END HireNewEmployee;

    PROCEDURE UpdateEmployeeDetails(p_employee_id IN NUMBER, p_name IN VARCHAR2, p_salary IN NUMBER) IS
    BEGIN
        UPDATE Employees
        SET name = p_name, salary = p_salary
        WHERE employee_id = p_employee_id;
        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Employee ID does not exist.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END UpdateEmployeeDetails;

    FUNCTION CalculateAnnualSalary(p_employee_id IN NUMBER) RETURN NUMBER IS
        v_salary NUMBER;
    BEGIN
        SELECT salary INTO v_salary
        FROM Employees
        WHERE employee_id = p_employee_id;
        RETURN v_salary * 12;  -- Assuming the salary is monthly
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Employee ID does not exist.');
            RETURN NULL;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
            RETURN NULL;
    END CalculateAnnualSalary;

END EmployeeManagement;
/
