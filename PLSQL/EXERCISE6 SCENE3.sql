DECLARE
    -- Define the new interest rate based on the policy
    v_new_interest_rate NUMBER := 5;

    -- Define a cursor to retrieve all loans
    CURSOR c_loans IS
        SELECT loan_id, interest_rate, amount
        FROM Loans
        FOR UPDATE;
    
    -- Define variables to hold cursor data
    v_loan_id Loans.loan_id%TYPE;
    v_current_interest_rate Loans.interest_rate%TYPE;
    v_amount Loans.amount%TYPE;
BEGIN
    -- Open and loop through the cursor
    FOR rec IN c_loans LOOP
        -- Update the interest rate based on the new policy
        v_loan_id := rec.loan_id;
        v_current_interest_rate := v_new_interest_rate;

        -- Update the interest rate in the Loans table
        UPDATE Loans
        SET interest_rate = v_current_interest_rate
        WHERE loan_id = v_loan_id;
        
        -- Print a confirmation message (optional)
        DBMS_OUTPUT.PUT_LINE('Updated loan ID ' || v_loan_id || ' with new interest rate: ' || v_current_interest_rate || '%');
    END LOOP;

    -- Commit the transaction
    COMMIT;

    -- Print a completion message
    DBMS_OUTPUT.PUT_LINE('Interest rates updated for all loans based on the new policy.');
EXCEPTION
    WHEN OTHERS THEN
        -- Handle any exceptions
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        ROLLBACK;
END;
/
