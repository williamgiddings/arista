function PLUGIN:PostPlayerSpawn(ply, lightSpawn, changeTeam)
	if not lightSpawn then
		ply:networkAristaVar("hunger", 100)
		-- todo: Make the hunger save and load from previous session?
	end
end

local LastDelay = CurTime()
function PLUGIN:PlayerTenthSecond(ply)
	if LastDelay > CurTime() then return end
	LastDelay = CurTime() + arista.config.plugins.hungerInterval

	local drain = arista.config.plugins.hungerDrain
	drain = hook.Run("HungerAdjustDrain") or drain

	local hunger = ply:getAristaVar("hunger") or 100
	hunger = math.Clamp(hunger - arista.config.plugins.hungerDrain, 0, 100)

	ply:setAristaVar("hunger", hunger)
end

function PLUGIN:StaminaAdjustPlayerSpeed(ply, run, walk)
	local hungry = (ply:getAristaVar("hunger") or 100) <= 10

	if hunger <= 10 then
		run = walk

		return run, walk
	end
end

function PLUGIN:StaminaAdjustDrain(ply, amt)
	local hungry = (ply:getAristaVar("hunger") or 100) <= 10

	if hungry then
		amt = amt * 1.5

		return amt
	end
end
