-- Provided by the UBox team. https://ubox.meteorthelizard.com

TOOL.Category = "Construction"
TOOL.Name = "#tool.breakertool.name"

TOOL.Information = {
	{
		name = "left"
	},
	{
		name = "right"
	}
}


if CLIENT then
	language.Add("Tool.breakertool.name","Breaker")
	language.Add("Tool.breakertool.desc","It's like the remover except it breaks stuff!")
	language.Add("Tool.breakertool.left","Primary: Break an entity")
	language.Add("Tool.breakertool.right","Secondary: Annihilate an entity")

	function TOOL.BuildCPanel(CPanel)
		CPanel:AddControl("Header",{
			Description = "#Tool.breakertool.desc"
		})

		CPanel:AddControl("Label",{
			Text = "Provided by:\n\nThe UBox team.\nhttps://ubox.meteorthelizard.com"
		})
	end
end


local fBreakEntity = function(tTrace,bMode,ePly)

	local eEnt = tTrace.Entity
	if not IsValid(eEnt) or not IsValid(ePly) or eEnt == game.GetWorld() or eEnt:IsPlayer() then
		return
	end


	if bMode then
		local obj_EffectData = EffectData()
		obj_EffectData:SetOrigin(tTrace.HitPos)
		util.Effect("Explosion",obj_EffectData)
	end


	if not SERVER then return true end


	-- Apply damage to entity to make it break / explode / die

	local obj_DamageInfo = DamageInfo()
	obj_DamageInfo:SetDamageType(DMG_DIRECT)
	obj_DamageInfo:SetAttacker(ePly)
	obj_DamageInfo:SetInflictor(IsValid(ePly:GetActiveWeapon()) and ePly:GetActiveWeapon() or ePly)
	obj_DamageInfo:SetDamage(1e9)
	obj_DamageInfo:SetDamageBonus(1e9)
	obj_DamageInfo:SetDamageForce((eEnt:GetPos() - ePly:GetPos()) * (not bMode and 1000 or 1000000))
	obj_DamageInfo:SetDamagePosition(tTrace.HitPos)
	obj_DamageInfo:SetReportedPosition(tTrace.HitPos)

	for I = 1,10 do -- Make absolutely sure this kills the entity
		eEnt:TakeDamageInfo(obj_DamageInfo)
	end


	-- GBombs Compat

	if eEnt.TriggerInput and (eEnt:GetClass()):sub(1,2) == "gb" then
		eEnt.MaxDelay = 0 -- Explode instantly
		eEnt:TriggerInput("Detonate",1)
	end


	timer.Simple(0,function()
		if not IsValid(eEnt) or not IsValid(ePly) then return end

		SafeRemoveEntityDelayed(eEnt,1) -- If it remains, just remove it after 1 second

		eEnt:Fire("break",1) -- Attempt engine-level break

	end)


	return true

end


function TOOL:LeftClick(tTrace)
	if fBreakEntity(tTrace,false,self:GetOwner()) then return true end

	return false
end


function TOOL:RightClick(tTrace)
	if fBreakEntity(tTrace,true,self:GetOwner()) then return true end

	return false
end


function TOOL:Reload()
	return false
end