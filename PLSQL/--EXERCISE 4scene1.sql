--EXERCISE 4scene1
CREATE OR REPLACE FUNCTION CalculateAge (
    p_birth_date IN DATE
) 
RETURN NUMBER
IS
    v_age NUMBER;
BEGIN
    -- Calculate the age in years
    v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, p_birth_date) / 12);

    RETURN v_age;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle any exceptions and return NULL or an error code
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        RETURN NULL;
END CalculateAge;
/
