--Exercise4scene2
CREATE OR REPLACE FUNCTION CalculateMonthlyInstallment (
    p_loan_amount IN NUMBER,
    p_annual_interest_rate IN NUMBER,
    p_loan_duration_years IN NUMBER
) 
RETURN NUMBER
IS
    v_monthly_interest_rate NUMBER;
    v_number_of_payments NUMBER;
    v_monthly_installment NUMBER;
BEGIN
    -- Calculate the monthly interest rate
    v_monthly_interest_rate := p_annual_interest_rate / 100 / 12;
    
    -- Calculate the total number of payments
    v_number_of_payments := p_loan_duration_years * 12;
    
    -- Calculate the monthly installment using the formula
    IF v_monthly_interest_rate > 0 THEN
        v_monthly_installment := (p_loan_amount * v_monthly_interest_rate) / 
            (1 - POWER(1 + v_monthly_interest_rate, -v_number_of_payments));
    ELSE
        -- If the interest rate is 0, just divide the amount by the number of payments
        v_monthly_installment := p_loan_amount / v_number_of_payments;
    END IF;

    RETURN v_monthly_installment;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle any exceptions and return NULL or an error code
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        RETURN NULL;
END CalculateMonthlyInstallment;
/
