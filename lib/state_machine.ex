# File    : state_machine.ex

defmodule Exdsl.StateMachine do
    @moduledoc """
Provides a macros for state machine definition. 
It implements erlang gen_fsm beahabiour.
"""
    
    defmacro __using__(_opts) do
        module = __CALLER__.module
        
        quote do
            import Exdsl.StateMachine
            
            def initialize do
                Exdsl.StateMachine.initialize unquote(module)
            end

        end         
    end 

    def initialize(module) do
        IO.puts ">> #{inspect module}"
    end

    defmacro event(tag, name) do
        quote do
            def event_to_string(unquote(tag)), do: unquote(name)
        end
    end 

    defmacro command(tag, name) do
        quote do
            def command_to_string(unquote(tag)), do: unquote(name)
        end
    end 
    
    defmacro resetEvents(event) do
        quote do
            def resetEvents, do: unquote(event)
        end
    end

    defmacro actions(state, list) do
        quote do
            def execute(unquote(state)) do
                { :actions, unquote(list) }
            end
        end
    end
    
    defmacro state(current, [do: { :"->", _line, blocks }]) do
        Enum.map blocks, ( fn {[event], next} ->
                              quote hygiene: [vars: false] do
                                  def handle(unquote(current), unquote(event)) do
                                      { :next, unquote(next) }
                                  end
                              end
                           end)
    end
end
 