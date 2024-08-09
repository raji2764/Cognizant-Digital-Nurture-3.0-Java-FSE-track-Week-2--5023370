--EXERCISE3SCENE3
CREATE OR REPLACE PROCEDURE TransferFunds (
    p_from_account_id IN accounts.account_id%TYPE,
    p_to_account_id IN accounts.account_id%TYPE,
    p_amount IN NUMBER
)
AS
    v_from_balance accounts.balance%TYPE;
    v_to_balance accounts.balance%TYPE;
    e_insufficient_funds EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_insufficient_funds, -20001);
BEGIN
    -- Lock the rows for the source and destination accounts
    SELECT balance INTO v_from_balance
    FROM accounts
    WHERE account_id = p_from_account_id
    FOR UPDATE;

    SELECT balance INTO v_to_balance
    FROM accounts
    WHERE account_id = p_to_account_id
    FOR UPDATE;

    -- Check if there are sufficient funds in the source account
    IF v_from_balance < p_amount THEN
        RAISE e_insufficient_funds;
    END IF;

    -- Update the balances of the source and destination accounts
    UPDATE accounts
    SET balance = balance - p_amount
    WHERE account_id = p_from_account_id;

    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_to_account_id;

    -- Commit the transaction
    COMMIT;

    -- Log success message
    DBMS_OUTPUT.PUT_LINE('Transferred ' || p_amount || ' from account ' || p_from_account_id || ' to account ' || p_to_account_id || '.');
EXCEPTION
    WHEN e_insufficient_funds THEN
        -- Handle insufficient funds error
        DBMS_OUTPUT.PUT_LINE('Error: Insufficient funds in account ' || p_from_account_id || '. Transfer failed.');
        ROLLBACK;
    WHEN OTHERS THEN
        -- Handle all other exceptions
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM || '. Transfer failed.');
        ROLLBACK;
END TransferFunds;
/
