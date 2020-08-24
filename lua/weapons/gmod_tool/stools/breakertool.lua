TOOL.Category = "Construction"
TOOL.Name = "#tool.breakertool.name"

if CLIENT then
	function TOOL.BuildCPanel(CPanel)
		CPanel:AddControl("Header",{
			Description = "#Tool.breakertool.desc"
		})
	end

	language.Add("Tool.breakertool.name","Breaker")
	language.Add("Tool.breakertool.desc","It's like the Remover except it breaks stuff!")
	language.Add("Tool.breakertool.left","Primary: Break an Object")
	language.Add("Tool.breakertool.right","Secondary: Annihilate an Object")
end

TOOL.Information = {
	{
		name = "left"
	},
	{
		name = "right"
	}
}

local effectData = EffectData() -- We do not have to re-create this
local damageInfo = DamageInfo()
damageInfo:SetDamageType(DMG_DIRECT)

local function DoBreak(tTrace,bMode,Ply)
	local Ent = tTrace.Entity
	if not IsValid(Ply) or not IsValid(Ent) or Ent == game.GetWorld() or Ent:IsPlayer() then
		return false
	end

	if bMode then
		effectData:SetOrigin(tTrace.HitPos)
		util.Effect("Explosion",effectData)
	end

	if SERVER then
		damageInfo:SetAttacker(Ply)
		damageInfo:SetInflictor(IsValid(Ply:GetActiveWeapon()) and Ply:GetActiveWeapon() or Ply)
		damageInfo:SetDamage(Ent:Health() or 1e9)
		Ent:TakeDamageInfo(damageInfo)

		if Ent.TriggerInput and string.Left(Ent:GetClass(),2) == "gb" then -- GBombs Compat
			Ent.MaxDelay = 0 -- Explode instantly
			Ent:TriggerInput("Detonate",1)
		end

		timer.Simple(0,function() -- One tick delay
			if not IsValid(Ent) then return end
			Ent:Fire("break",1) -- If applying damage did not work we try to call the internal break function

			timer.Simple(0.1,function() -- If that did not work we simply remove it now
				if not IsValid(Ent) then return end
				Ent:Remove()
			end)
		end)
	end

	return true
end

function TOOL:LeftClick(tTrace)
	if DoBreak(tTrace,false,self:GetOwner()) then return true end

	return false
end

function TOOL:RightClick(tTrace)
	if DoBreak(tTrace,true,self:GetOwner()) then return true end

	return false
end

function TOOL:Reload()

end