defmodule BankAccountTest do
  use ExUnit.Case
  alias BankAccount


  test "test withdrawals and deposits" do
    {:ok, pid} = BankAccount.start_link(1000)

    tasks =
      1..5
      |> Enum.map(fn _ ->
        Task.async(fn ->
          BankAccount.deposit(pid, 100)
          BankAccount.withdraw(pid, 50)
        end)
      end)

    Enum.each(tasks, &Task.await/1)

    assert BankAccount.balance(pid) == 1250
  end

end
