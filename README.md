# P2P Lending Contract

The P2P Lending Contract facilitates peer-to-peer lending, where users can request loans, provide collateral, fund loan requests, and handle repayments. It enables decentralized lending with a secure mechanism for collateral and repayment management.

## Overview

This contract allows borrowers to request loans by providing collateral, and lenders to fund these loan requests. The contract also manages loan repayments, ensuring that the borrower repays the loan with interest. If the borrower fails to repay on time, the lender can claim the collateral.

## Key Features

- **Loan Request with Collateral:** Borrowers can submit loan requests along with collateral to secure the loan.
- **Loan Funding:** Lenders can browse and fund available loan requests.
- **Repayment Handling:** Borrowers repay the loan amount along with the agreed interest. The contract ensures repayments are managed properly.
- **Collateral Claim:** In the event of non-repayment, lenders can claim the collateral provided by the borrower.
- **Event Logging:** The contract emits events for important actions such as loan requests, funding, repayments, and collateral claims for transparency.

## How It Works

1. **Loan Request:**  
   Borrowers create a loan request by specifying the loan amount, repayment duration, and collateral. The collateral is locked in the contract until the loan is repaid or claimed.
   
2. **Loan Funding:**  
   Lenders can browse available loan requests and choose to fund one. Once funded, the borrower receives the loan amount.
   
3. **Repayment:**  
   Borrowers are required to repay the loan amount with interest within the specified repayment period. Partial repayments may be supported depending on the contract setup.
   
4. **Collateral Claim:**  
   If the borrower does not repay the loan on time, the lender can claim the collateral. The contract ensures that only the correct lender can claim the collateral after the due date.
   
5. **Event Logging:**  
   The contract emits events for loan requests, funding, repayments, and collateral claims to provide transparency and easy tracking of transactions.

## Events

- **LoanRequested:**  
  Emitted when a borrower requests a loan. Includes borrower address, loan amount, collateral amount, and repayment deadline.

- **LoanFunded:**  
  Emitted when a lender funds a loan. Includes lender address, loan amount, and borrower address.

- **RepaymentMade:**  
  Emitted when a borrower makes a repayment. Includes borrower address, repayment amount, and remaining balance.

- **CollateralClaimed:**  
  Emitted when a lender claims the collateral due to non-repayment. Includes lender address, borrower address, and collateral amount.

