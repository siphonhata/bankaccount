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
iex> task = Enum.map(1..5, fn _ -> Task.async(fn -> BankAccount.deposit(pid, 100) end) end)[
%Task{
    mfa: {:erlang, :apply, 2},
    owner: #PID<0.131.0>,
    pid: #PID<0.135.0>,
    ref: #Reference<0.1169462940.1466761217.196808>
  },
  %Task{
    mfa: {:erlang, :apply, 2},
    owner: #PID<0.131.0>,
    pid: #PID<0.136.0>,
    ref: #Reference<0.1169462940.1466761217.196809>
  },
  %Task{
    mfa: {:erlang, :apply, 2},
    owner: #PID<0.131.0>,
    pid: #PID<0.137.0>,
    ref: #Reference<0.1169462940.1466761217.196810>
  },
  %Task{
    mfa: {:erlang, :apply, 2},
    owner: #PID<0.131.0>,
    pid: #PID<0.138.0>,
    ref: #Reference<0.1169462940.1466761217.196811>
  },
  %Task{
    mfa: {:erlang, :apply, 2},
    owner: #PID<0.131.0>,
    pid: #PID<0.139.0>,
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
1500
```