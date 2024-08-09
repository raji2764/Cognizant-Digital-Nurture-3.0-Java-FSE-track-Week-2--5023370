CREATE OR REPLACE PROCEDURE AddNewCustomer (
    p_customer_id IN customers.customer_id%TYPE,
    p_customer_name IN customers.customer_name%TYPE,
    p_birth_date IN customers.birth_date%TYPE,
    p_email IN customers.email%TYPE,
    p_balance IN customers.balance%TYPE
)
AS
    e_customer_exists EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_customer_exists, -1);
BEGIN
    -- Attempt to insert a new customer
    INSERT INTO customers (customer_id, customer_name, birth_date, email, balance)
    VALUES (p_customer_id, p_customer_name, p_birth_date, p_email, p_balance);

    -- Commit the transaction if successful
    COMMIT;

    -- Log success message
    DBMS_OUTPUT.PUT_LINE('Customer with ID ' || p_customer_id || ' added successfully.');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        -- Handle duplicate customer ID
        DBMS_OUTPUT.PUT_LINE('Error: Customer with ID ' || p_customer_id || ' already exists. Insertion failed.');
        ROLLBACK;
    WHEN OTHERS THEN
        -- Handle all other exceptions
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM || '. Insertion failed.');
        ROLLBACK;
END AddNewCustomer;
/
