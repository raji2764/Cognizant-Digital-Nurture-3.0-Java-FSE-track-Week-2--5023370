DECLARE
    CURSOR cur_loans IS
        SELECT l.loan_id, l.customer_id, l.due_date, c.customer_name, c.email
        FROM loans l
        JOIN customers c ON l.customer_id = c.customer_id
        WHERE l.due_date BETWEEN SYSDATE AND SYSDATE + 30;

    v_loan_id loans.loan_id%TYPE;
    v_customer_id loans.customer_id%TYPE;
    v_due_date loans.due_date%TYPE;
    v_customer_name customers.customer_name%TYPE;
    v_email customers.email%TYPE;
BEGIN
    FOR rec IN cur_loans LOOP
        v_loan_id := rec.loan_id;
        v_customer_id := rec.customer_id;
        v_due_date := rec.due_date;
        v_customer_name := rec.customer_name;
        v_email := rec.email;

        -- Print reminder message
        DBMS_OUTPUT.PUT_LINE('Reminder: Dear ' || v_customer_name || 
                             ', your loan with ID ' || v_loan_id || 
                             ' is due on ' || TO_CHAR(v_due_date, 'DD-MON-YYYY') || 
                             '. Please make sure to complete your payment on time. Thank you.');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
