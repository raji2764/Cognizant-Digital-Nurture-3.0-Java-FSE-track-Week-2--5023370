CREATE OR REPLACE PROCEDURE SafeTransferFunds (
    p_from_account_id IN accounts.account_id%TYPE,
    p_to_account_id IN accounts.account_id%TYPE,
    p_amount IN NUMBER
) 
AS
    v_from_balance accounts.balance%TYPE;
    v_to_balance accounts.balance%TYPE;
    e_insufficient_funds EXCEPTION;
BEGIN
    -- Get the balance of the from account
    SELECT balance INTO v_from_balance
    FROM accounts
    WHERE account_id = p_from_account_id
    FOR UPDATE;

    -- Check if there are sufficient funds in the from account
    IF v_from_balance < p_amount THEN
        RAISE e_insufficient_funds;
    END IF;

    -- Get the balance of the to account
    SELECT balance INTO v_to_balance
    FROM accounts
    WHERE account_id = p_to_account_id
    FOR UPDATE;

    -- Deduct the amount from the from account
    UPDATE accounts
    SET balance = balance - p_amount
    WHERE account_id = p_from_account_id;

    -- Add the amount to the to account
    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_to_account_id;

    -- Commit the transaction
    COMMIT;

    -- Log success message
    DBMS_OUTPUT.PUT_LINE('Transfer of ' || p_amount || ' from account ' || p_from_account_id || ' to account ' || p_to_account_id || ' was successful.');
EXCEPTION
    WHEN e_insufficient_funds THEN
        -- Log insufficient funds error and rollback
        DBMS_OUTPUT.PUT_LINE('Error: Insufficient funds in account ' || p_from_account_id || '. Transfer failed.');
        ROLLBACK;
    WHEN OTHERS THEN
        -- Handle all other exceptions
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM || '. Transfer failed.');
        ROLLBACK;
END SafeTransferFunds;
/
