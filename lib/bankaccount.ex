defmodule BankAccount do
#
  use GenServer

  @moduledoc """
  This is a bank account module, can perfom functions like Deposit, withdraw and view balance.
  """


  @doc """

  Function to initialise the bank balance and create a process. Abuti Small

  ## Examples

      iex> pid = BankAccount.start_link
      {:ok, #PID<0.199.0>}

  """
  def start_link(initial_balance) do
    GenServer.start_link(__MODULE__, initial_balance)
  end

 @doc """

  Function to deposit the amount into the bank.

  ## Examples

      iex> pid = BankAccount.start_link
      {:ok, #PID<0.199.0>}
      iex> BankAccount.deposit(pid, 120)
      :ok

  """
  def deposit(pid, amount) do
    GenServer.cast(pid, {:deposit, amount})
  end

  @doc """

  Function to withdraw the amount into the bank.

  ## Examples

      iex> pid = BankAccount.start_link
      {:ok, #PID<0.199.0>}
      iex> BankAccount.withdraw(pid, 120)
      {:error, "Insufficient funds"}

  """
  def withdraw(pid, amount) do
    GenServer.call(pid, {:withdraw, amount})
  end


    @doc """

  Function to check  the balance amount.

  ## Examples

      iex> pid = BankAccount.start_link
      {:ok, #PID<0.199.0>}
      iex> BankAccount.balance(pid, 120)
      0

  """
  def balance(pid) do
    GenServer.call(pid, :balance)
  end

  # Callbacks

  def handle_call({:withdraw, amount}, _from, balance) when balance >= amount do
    {:reply, {:ok, balance - amount}, balance - amount}
  end

  def handle_call({:withdraw, _amount}, _from, balance) do
    {:reply, {:error, "Insufficient funds"}, balance}
  end

  def handle_call(:balance, _from, balance) do
    {:reply, balance, balance}
  end

  def handle_cast({:deposit, amount}, balance) do
    {:noreply, balance + amount}
  end

  def init(initial_balance) do
    {:ok, initial_balance}
  end

end
