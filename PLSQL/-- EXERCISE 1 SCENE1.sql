-- EXERCISE 1
DECLARE
    CURSOR cur_customers IS
        SELECT customer_id, loan_id, interest_rate, birth_date
        FROM customers
        JOIN loans ON customers.customer_id = loans.customer_id;

    v_customer_id customers.customer_id%TYPE;
    v_loan_id loans.loan_id%TYPE;
    v_interest_rate loans.interest_rate%TYPE;
    v_birth_date customers.birth_date%TYPE;
    v_age NUMBER;
    v_new_interest_rate loans.interest_rate%TYPE;
BEGIN
    FOR rec IN cur_customers LOOP
        v_customer_id := rec.customer_id;
        v_loan_id := rec.loan_id;
        v_interest_rate := rec.interest_rate;
        v_birth_date := rec.birth_date;

        -- Calculate age
        v_age := TRUNC((SYSDATE - v_birth_date) / 365.25);

        IF v_age > 60 THEN
            -- Apply 1% discount to the current interest rate
            v_new_interest_rate := v_interest_rate * 0.99;

            -- Update the interest rate in the loans table
            UPDATE loans
            SET interest_rate = v_new_interest_rate
            WHERE loan_id = v_loan_id;

            -- Output message
            DBMS_OUTPUT.PUT_LINE('Customer ID: ' || v_customer_id || ' Loan ID: ' || v_loan_id || ' Old Interest Rate: ' || v_interest_rate || ' New Interest Rate: ' || v_new_interest_rate);
        END IF;
    END LOOP;

    -- Commit the transaction
    COMMIT;

    -- Output completion message
    DBMS_OUTPUT.PUT_LINE('Interest rates updated successfully.');
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
