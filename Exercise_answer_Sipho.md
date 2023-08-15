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

## 2. Concurrent Deposits

 ```sh
 iex> {:ok, pid} = BankAccount.start_link(1000)
 {:ok, #PID<0.132.0>}
```

```sh
iex> task = Enum.map(1..5, fn _ -> spawn(fn -> BankAccount.deposit(pid, 100) end) end)
[#PID<0.133.0>, #PID<0.134.0>, #PID<0.135.0>, #PID<0.136.0>, #PID<0.137.0>]
```

```sh
iex> Enum.each(task, &Task.await/1)
:ok
```

```sh
iex> BankAccount.balance(pid)
1500
```

## 3. Concurrent Withdrawals

 ```sh
 iex> {:ok, pid} = BankAccount.start_link(1000)
 {:ok, #PID<0.142.0>}
```

```sh
iex> task = Enum.map(1..5, fn _ -> Task.async(fn -> BankAccount.withdraw(pid, 100) end) end)
%Task{
    mfa: {:erlang, :apply, 2},
    owner: #PID<0.141.0>,
    pid: #PID<0.145.0>,
    ref: #Reference<0.1169462940.1466761217.196808>
  },
  %Task{
    mfa: {:erlang, :apply, 2},
    owner: #PID<0.141.0>,
    pid: #PID<0.146.0>,
    ref: #Reference<0.1169462940.1466761217.196809>
  },
  %Task{
    mfa: {:erlang, :apply, 2},
    owner: #PID<0.141.0>,
    pid: #PID<0.147.0>,
    ref: #Reference<0.1169462940.1466761217.196810>
  },
  %Task{
    mfa: {:erlang, :apply, 2},
    owner: #PID<0.141.0>,
    pid: #PID<0.148.0>,
    ref: #Reference<0.1169462940.1466761217.196811>
  },
  %Task{
    mfa: {:erlang, :apply, 2},
    owner: #PID<0.141.0>,
    pid: #PID<0.149.0>,
    ref: #Reference<0.1169462940.1466761217.196812>
  }
]
```

```sh
iex> Enum.each(task, &Task.await/1)
:ok
```

```sh
iex> BankAccount.balance(pid)
500
```

## 4. Mixed Concurrent Deposits and Withdrawals

```sh
iex> {:ok, pid} = BankAccount.start_link(1000)
{:ok, #PID<0.161.0>}
```

```sh
iex> task_dep = Enum.map(1..5, fn _ -> spawn(fn -> BankAccount.deposit(pid, 100) end) end)
[#PID<0.177.0>, #PID<0.178.0>, #PID<0.179.0>, #PID<0.180.0>, #PID<0.181.0>]
```

```sh
iex> task_with = Enum.map(1..5, fn _ -> spawn(fn -> BankAccount.withdraw(pid, 50) end) end)
[#PID<0.182.0>, #PID<0.183.0>, #PID<0.184.0>, #PID<0.185.0>, #PID<0.186.0>]
```

```sh
iex> BankAccount.balance(pid)  
1250
```

## 5. Error handling

```sh
iex> {:ok, pid} = BankAccount.start_link(500)
{:ok, #PID<0.197.0>}
```

```sh
iex> BankAccount.withdraw(pid, 600)
{:error, "Insufficient funds"}
```

## 6. Writing Tests for Concurrency

- Check the Unit test on the project test/bank_account_test file.