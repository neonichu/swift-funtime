#!/usr/bin/xcrun swift

class BankAccount {
    var balance: Double = 0.0
    
    func deposit(amount: Double) {
        balance += amount
    }
}

let account = BankAccount()
account.deposit(100)
print(account.balance)

let depositor = BankAccount.deposit
depositor(account)(100)
print(account.balance)

BankAccount.deposit(account)(100)
print(account.balance)
