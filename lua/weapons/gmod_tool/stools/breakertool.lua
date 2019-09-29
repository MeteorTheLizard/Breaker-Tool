TOOL.Category		= "Construction"
TOOL.Name			= "#Tool.breakertool.name"

if CLIENT then
	language.Add("Tool.breakertool.name","Breaker")
	language.Add("Tool.breakertool.desc","Its like the Remover, except it breaks stuff!")
	language.Add("Tool.breakertool.0","Primary: Break an Object")
end

local function ProperValid(trace)
	if not trace.Entity:IsValid() then return false end
	if trace.Entity:IsPlayer() then return false end
	if SERVER and not trace.Entity:GetPhysicsObject():IsValid() then return false end
	return true
end

function TOOL:LeftClick(trace)
	if CLIENT and ProperValid(trace) then return true end
	if not ProperValid(trace) then return false end
	
	if SERVER then
		trace.Entity:Fire("break",1,0)
		if trace.Entity:IsValid() then
			trace.Entity:TakeDamage(1e9,self:GetOwner(),Entity(0))
		end
	end
	
	return true
end

function TOOL:RightClick()
	return false
end

function TOOL:Reload()
	return false
end

function TOOL:Think()
	if CLIENT then return end
	local pl = self:GetOwner()
	local wep = pl:GetActiveWeapon()
	if not wep:IsValid() or wep:GetClass() != "gmod_tool" or pl:GetInfo("gmod_toolmode") != "breakertool" then return end
	local trace = pl:GetEyeTrace()
	if not ProperValid(trace) then return end
end

function TOOL.BuildCPanel(cp)
	cp:AddControl("Header",{Text = "#Tool.breakertool.name",Description = "#Tool.breakertool.desc"})
end