-- Package Specification
CREATE OR REPLACE PACKAGE CustomerManagement AS
    -- Procedure to add a new customer
    PROCEDURE AddNewCustomer(p_customer_id IN NUMBER, p_name IN VARCHAR2, p_balance IN NUMBER);
    
    -- Procedure to update customer details
    PROCEDURE UpdateCustomerDetails(p_customer_id IN NUMBER, p_name IN VARCHAR2, p_balance IN NUMBER);
    
    -- Function to get customer balance
    FUNCTION GetCustomerBalance(p_customer_id IN NUMBER) RETURN NUMBER;
END CustomerManagement;
/
  
-- Package Body
CREATE OR REPLACE PACKAGE BODY CustomerManagement AS

    PROCEDURE AddNewCustomer(p_customer_id IN NUMBER, p_name IN VARCHAR2, p_balance IN NUMBER) IS
    BEGIN
        INSERT INTO Customers (customer_id, name, balance)
        VALUES (p_customer_id, p_name, p_balance);
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Customer ID already exists.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END AddNewCustomer;

    PROCEDURE UpdateCustomerDetails(p_customer_id IN NUMBER, p_name IN VARCHAR2, p_balance IN NUMBER) IS
    BEGIN
        UPDATE Customers
        SET name = p_name, balance = p_balance
        WHERE customer_id = p_customer_id;
        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Customer ID does not exist.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END UpdateCustomerDetails;

    FUNCTION GetCustomerBalance(p_customer_id IN NUMBER) RETURN NUMBER IS
        v_balance NUMBER;
    BEGIN
        SELECT balance INTO v_balance
        FROM Customers
        WHERE customer_id = p_customer_id;
        RETURN v_balance;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Customer ID does not exist.');
            RETURN NULL;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
            RETURN NULL;
    END GetCustomerBalance;

END CustomerManagement;
/
