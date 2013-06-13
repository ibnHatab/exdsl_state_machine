# ExdslStateMachine


Martin Fowler's State Machine DSL with Elixir

```ruby
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

```
