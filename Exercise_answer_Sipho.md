## 1. Basic Operattions
 
 ```sh
 iex> {:ok, pid} = BankAccount.start_link(500)
 {:ok, #PID<0.132.0>}
```

```sh
 iex> balance = BankAccount.balance(pid)
 500
```

```sh
 iex> BankAccount.deposit(pid, 300)
 :ok
```

```sh
 iex> balance = BankAccount.balance(pid)
 800
```

```sh
 iex> BankAccount.withdraw(pid, 200)          
 {:ok, 600}
```

```sh
 iex> balance = BankAccount.balance(pid)
 600
 ```