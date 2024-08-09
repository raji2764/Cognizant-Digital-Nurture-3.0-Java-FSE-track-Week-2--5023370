--EXERCISE7 SCENE3  
-- Package Specification
CREATE OR REPLACE PACKAGE AccountOperations AS
    -- Procedure to open a new account
    PROCEDURE OpenNewAccount(p_account_id IN NUMBER, p_customer_id IN NUMBER, p_initial_balance IN NUMBER);
    
    -- Procedure to close an account
    PROCEDURE CloseAccount(p_account_id IN NUMBER);
    
    -- Function to get the total balance of a customer across all accounts
    FUNCTION GetTotalBalance(p_customer_id IN NUMBER) RETURN NUMBER;
END AccountOperations;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY AccountOperations AS

    PROCEDURE OpenNewAccount(p_account_id IN NUMBER, p_customer_id IN NUMBER, p_initial_balance IN NUMBER) IS
    BEGIN
        INSERT INTO Accounts (account_id, customer_id, balance)
        VALUES (p_account_id, p_customer_id, p_initial_balance);
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Account ID already exists.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END OpenNewAccount;

    PROCEDURE CloseAccount(p_account_id IN NUMBER) IS
    BEGIN
        DELETE FROM Accounts
        WHERE account_id = p_account_id;
        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Account ID does not exist.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END CloseAccount;

    FUNCTION GetTotalBalance(p_customer_id IN NUMBER) RETURN NUMBER IS
        v_total_balance NUMBER;
    BEGIN
        SELECT NVL(SUM(balance), 0) INTO v_total_balance
        FROM Accounts
        WHERE customer_id = p_customer_id;
        RETURN v_total_balance;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Customer ID does not exist or has no accounts.');
            RETURN 0;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
            RETURN 0;
    END GetTotalBalance;

END AccountOperations;
/
