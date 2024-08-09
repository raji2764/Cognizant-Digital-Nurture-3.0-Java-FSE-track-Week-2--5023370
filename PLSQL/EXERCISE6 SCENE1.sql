DECLARE
    -- Define a cursor to retrieve transactions for the current month
    CURSOR c_transactions IS
        SELECT t.transaction_id, t.transaction_date, t.amount, a.customer_id, c.customer_name
        FROM Transactions t
        JOIN Accounts a ON t.account_id = a.account_id
        JOIN Customers c ON a.customer_id = c.customer_id
        WHERE EXTRACT(MONTH FROM t.transaction_date) = EXTRACT(MONTH FROM SYSDATE)
          AND EXTRACT(YEAR FROM t.transaction_date) = EXTRACT(YEAR FROM SYSDATE);
    
    -- Define variables to hold cursor data
    v_customer_id Customers.customer_id%TYPE;
    v_customer_name Customers.customer_name%TYPE;
    v_transaction_id Transactions.transaction_id%TYPE;
    v_transaction_date Transactions.transaction_date%TYPE;
    v_amount Transactions.amount%TYPE;
    
    -- To accumulate transactions for each customer
    TYPE t_transactions IS TABLE OF RECORD (
        transaction_id Transactions.transaction_id%TYPE,
        transaction_date Transactions.transaction_date%TYPE,
        amount Transactions.amount%TYPE
    ) INDEX BY BINARY_INTEGER;
    
    v_transaction_list t_transactions;
    v_index INTEGER := 1;
BEGIN
    -- Open and loop through the cursor
    FOR rec IN c_transactions LOOP
        -- Accumulate transaction details in the array
        v_transaction_list(v_index).transaction_id := rec.transaction_id;
        v_transaction_list(v_index).transaction_date := rec.transaction_date;
        v_transaction_list(v_index).amount := rec.amount;
        
        v_customer_id := rec.customer_id;
        v_customer_name := rec.customer_name;
        
        v_index := v_index + 1;
    END LOOP;
    
    -- Print the statement for each customer
    -- Note: In a real scenario, you might use a reporting tool or output to a file instead of DBMS_OUTPUT
    FOR i IN 1 .. v_index - 1 LOOP
        DBMS_OUTPUT.PUT_LINE('Customer: ' || v_customer_name);
        DBMS_OUTPUT.PUT_LINE('Transaction ID: ' || v_transaction_list(i).transaction_id);
        DBMS_OUTPUT.PUT_LINE('Transaction Date: ' || TO_CHAR(v_transaction_list(i).transaction_date, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Amount: ' || v_transaction_list(i).amount);
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    END LOOP;
    
    -- If no transactions found, print a message
    IF v_index = 1 THEN
        DBMS_OUTPUT.PUT_LINE('No transactions found for the current month.');
    END IF;

END;
/
