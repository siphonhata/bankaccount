defmodule BankAccount do

  require Logger
  use GenServer

  def start_link(acc_num, initial_balance \\ 0) when is_number(initial_balance) and initial_balance >= 0 do
    result = GenServer.start_link(__MODULE__, initial_balance, name: spec_proc(acc_num))
    result
  end

  def balance(acc_num) do
    acc_num
    |> spec_proc()
    |> GenServer.call( {:balance,acc_num})
  end

  def deposit(acc_num,amount) when is_number(amount) and amount > 0 do
    Logger.info("\nDeposit of R#{amount} requested.")
    acc_num
    |> spec_proc()
    GenServer.cast(:bank_account, {:deposit, amount, acc_num})
  end

  def withdraw(acc_num, amount) when is_number(amount) do
    Logger.info("Amount withdrawed R#{amount}.")
    acc_num
    |> spec_proc()
    |> GenServer.call( {:withdraw, amount,acc_num})
  end

  def transfer(from_account, to_account, amount) do
    case BankAccount.withdraw(from_account, amount) do
      {:ok, _} ->
      case BankAccount.deposit(to_account, amount) do
        {:ok, _reason} -> {:ok, "Transfer successful"}
        error -> error
      end
      {:error, _reason} -> {:error, "Insufficient funds"}
    end
  end


  # Callbacks
  #----------------------------------------------------------------------------------------

  def handle_call({:withdraw, amount, acc_num}, _from, balance) when balance >= amount do
    new_balance = balance - amount
    Logger.info("Withdrawal of R#{amount} made. New balance: R#{new_balance} From this account #{acc_num}")
    {:reply, {:ok, new_balance}, new_balance}
  end

  def handle_call({:withdraw, _amount, _acc_num}, _from, balance) do
    Logger.warning("Withdrawal failed due to insufficient funds.")
    {:reply, {:error, "Insufficient funds"}, balance}
  end

  def handle_call({:balance, acc_num}, _from, bal) do
    #Logger.info("Account number: #{acc_num}")
    Logger.info("Balance: #{bal}")
    {:reply, bal, acc_num}
  end

  def handle_cast({:deposit, amount, acc_num}, balance) do
    new_balance = balance + amount
    IO.puts "Balance is R#{new_balance}"
    Logger.info("\nAccount number: #{acc_num}.\nDeposit of R#{amount} made.\n New balance: R#{new_balance}.")
    {:noreply, new_balance}
  end

  def init(initial_balance) do
    Logger.info("\nBank Account created.\nInitial balance: R#{initial_balance}")
    {:ok, initial_balance}
  end

  def spec_proc(acc_num) do
    {:via, Registry, {BankRegistry, acc_num}}
  end
end
