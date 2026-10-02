-- Shared code: lives in ReplicatedStorage.Shared, usable from server and client.
local Greeting = {}

function Greeting.forPlayer(name: string): string
	return `Hello, {name}! Synced from GitHub.`
end

return Greeting
