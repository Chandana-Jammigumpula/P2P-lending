// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract P2PLending {
    // Struct to represent a loan
    struct Loan {
        uint id;                // Unique identifier for the loan
        address payable lender; // Address of the lender
        address payable borrower; // Address of the borrower
        uint amount;            // Amount of the loan
        uint collateral;        // Collateral amount provided by the borrower
        uint interestRate;      // Interest rate for the loan
        uint dueDate;           // Due date for the loan repayment
        bool repaid;            // Boolean to check if the loan is repaid
    }

    uint public loanCount; // Total number of loans
    mapping(uint => Loan) public loans; // Mapping to store loans by their ID

    // Event to be emitted when a loan is requested
    event LoanRequested(uint id, address borrower, uint amount, uint collateral);

    // Event to be emitted when a loan is repaid
    event LoanRepaid(uint id, address borrower);

    // Borrowers request a loan by locking collateral
    function requestLoan(uint _amount, uint _collateral, uint _interestRate, uint _dueDate) public payable {
        require(msg.value == _collateral, "Incorrect collateral amount"); // Ensure the collateral matches the sent value

        loanCount++; // Increment the loan count
        loans[loanCount] = Loan(loanCount, payable(address(0)), payable(msg.sender), _amount, _collateral, _interestRate, _dueDate, false); // Create a new loan request

        emit LoanRequested(loanCount, msg.sender, _amount, _collateral); // Emit an event for the loan request
    }

    // Lenders fund the loan
    function fundLoan(uint _id) public payable {
        Loan storage loan = loans[_id]; // Retrieve the loan from the mapping

        require(loan.id > 0 && loan.id <= loanCount, "Loan does not exist"); // Validate loan ID
        require(msg.value == loan.amount, "Incorrect amount sent"); // Ensure the correct amount is sent
        require(loan.lender == address(0), "Loan already funded"); // Ensure the loan is not already funded

        loan.lender = payable(msg.sender); // Set the lender for the loan
        loan.lender.transfer(msg.value); // Transfer the loan amount to the borrower
    }

    // Borrowers repay the loan with interest
    function repayLoan(uint _id) public payable {
        Loan storage loan = loans[_id]; // Retrieve the loan from the mapping

        require(loan.id > 0 && loan.id <= loanCount, "Loan does not exist"); // Validate loan ID
        require(msg.sender == loan.borrower, "Not your loan"); // Ensure the caller is the borrower
        require(!loan.repaid, "Loan already repaid"); // Ensure the loan is not already repaid
        require(msg.value == loan.amount + (loan.amount * loan.interestRate / 100), "Incorrect repayment amount"); // Ensure the correct repayment amount
        require(block.timestamp <= loan.dueDate, "Loan overdue"); // Ensure the loan is not overdue

        loan.repaid = true; // Mark the loan as repaid
        loan.lender.transfer(msg.value); // Transfer the repayment amount to the lender
        payable(loan.borrower).transfer(loan.collateral); // Return collateral to the borrower

        emit LoanRepaid(_id, loan.borrower); // Emit an event for the loan repayment
    }

    // Function to claim collateral if the loan is not repaid on time
    function claimCollateral(uint _id) public {
        Loan storage loan = loans[_id]; // Retrieve the loan from the mapping

        require(loan.id > 0 && loan.id <= loanCount, "Loan does not exist"); // Validate loan ID
        require(msg.sender == loan.lender, "Not the lender"); // Ensure the caller is the lender
        require(!loan.repaid, "Loan already repaid"); // Ensure the loan is not already repaid
        require(block.timestamp > loan.dueDate, "Loan not overdue"); // Ensure the loan is overdue

        loan.repaid = true; // Mark the loan as repaid
        payable(msg.sender).transfer(loan.collateral); // Transfer collateral to the lender
    }
}
