-- Client entry point: lives in StarterPlayer.StarterPlayerScripts.Client.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Greeting = require(ReplicatedStorage.Shared.Greeting)

print("[client]", Greeting.forPlayer(Players.LocalPlayer.Name))
