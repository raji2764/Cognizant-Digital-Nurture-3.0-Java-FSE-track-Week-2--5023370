DECLARE
    CURSOR cur_customers IS
        SELECT customer_id, balance
        FROM customers;

    v_customer_id customers.customer_id%TYPE;
    v_balance customers.balance%TYPE;
BEGIN
    FOR rec IN cur_customers LOOP
        v_customer_id := rec.customer_id;
        v_balance := rec.balance;

        IF v_balance > 10000 THEN
            -- Update the IsVIP flag to TRUE for customers with balance over $10,000
            UPDATE customers
            SET IsVIP = 'TRUE'
            WHERE customer_id = v_customer_id;

            -- Output message
            DBMS_OUTPUT.PUT_LINE('Customer ID: ' || v_customer_id || ' is now a VIP.');
        END IF;
    END LOOP;

    -- Commit the transaction
    COMMIT;

    -- Output completion message
    DBMS_OUTPUT.PUT_LINE('VIP status updated successfully.');
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
