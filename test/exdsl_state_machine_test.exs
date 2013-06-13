Code.require_file "test_helper.exs", __DIR__

# File    : exdsl_state_machine_test.exs

defmodule BasicSMTest do
    @moduledoc """
Provides a test for Miss Grant's controller from DSL book
"""
    use Exdsl.StateMachine

    event :doorClosed,   "D1CL"
    event :drawerOpened, "D2OP"
    event :lightOn,      "L1ON"
    event :doorOpened,   "D1OP"
    event :panelClosed,  "PNCL"

    command :unlockPanel, "PNUL"
    command :lockPanel,   "PNLK"
    command :lockDoor,    "D1LK"
    command :unlockDoor,  "D1UL"

    resetEvents :doorOpened

    actions :idle, [:unlockDoor, :lockPanel]
    state :idle do
        :doorClosed -> :active
    end

    state :active do
        :drawerOpened -> :waitingForLight
        :lightOn -> :waitingForDrawer
    end

    state :waitingForLight do
        :lightOn -> :unlockedPanel
    end

    state :waitingForDrawer do
        :drawerOpened -> :unlockedPanel
    end

    actions :unlockedPanel, [:unlockPanel, :lockDoor]
    state :unlockedPanel do
        :panelClosed -> :idle
    end
    
end

defmodule Exdsl.StateMachine.Test do
  use ExUnit.Case

  test "API acess" do
      BasicSMTest.initialize
      :ok
  end

  test "event name mapping" do
      assert BasicSMTest.event_to_string(:doorClosed)  == "D1CL"
      assert BasicSMTest.event_to_string(:panelClosed) == "PNCL"
  end

  test "command name mapping" do
      assert BasicSMTest.command_to_string(:unlockPanel)  == "PNUL"
  end

  test "reset event" do
      assert BasicSMTest.resetEvents == :doorOpened
  end

  test "handle event" do
      assert BasicSMTest.handle(:waitingForLight, :lightOn) == { :next, :unlockedPanel }
  end

  test "handle actions" do
      assert BasicSMTest.execute(:idle) == { :actions, [:unlockDoor, :lockPanel] }
  end


end

