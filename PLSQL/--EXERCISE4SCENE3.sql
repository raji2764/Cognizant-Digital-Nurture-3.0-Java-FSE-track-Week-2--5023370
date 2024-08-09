--EXERCISE4SCENE3
CREATE OR REPLACE FUNCTION HasSufficientBalance (
    p_account_id IN accounts.account_id%TYPE,
    p_amount IN NUMBER
) 
RETURN BOOLEAN
IS
    v_balance accounts.balance%TYPE;
BEGIN
    -- Retrieve the current balance for the specified account
    SELECT balance INTO v_balance
    FROM accounts
    WHERE account_id = p_account_id;
    
    -- Check if the balance is sufficient
    IF v_balance >= p_amount THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Handle the case where the account ID does not exist
        DBMS_OUTPUT.PUT_LINE('Error: Account ID ' || p_account_id || ' does not exist.');
        RETURN FALSE;
    WHEN OTHERS THEN
        -- Handle other exceptions
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        RETURN FALSE;
END HasSufficientBalance;
/
