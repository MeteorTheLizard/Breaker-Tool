TOOL.Category = "Construction"
TOOL.Name = "#tool.breakertool.name"

if CLIENT then
    language.Add("Tool.breakertool.name", "Breaker")
    language.Add("Tool.breakertool.desc", "Its like the Remover, except it breaks stuff!")
    language.Add("Tool.breakertool.left", "Primary: Break an Object")
    language.Add("Tool.breakertool.right", "Secondary: Annihilate an Object")
end

TOOL.Information = {
    {
        name = "left",
    },
    {
        name = "right",
    }
}

local function DoBreak(Trace, mode, ply)
    local ent = Trace.Entity
    if not IsValid(ply) or not IsValid(ent) or ent:IsPlayer() then return false end

    if not mode then
        local ED = EffectData()
        ED:SetOrigin(Trace.HitPos)
        util.Effect("Explosion", ED)
    end

    if SERVER then
        ent:Fire("break", 1, 0)

        if ent:IsNPC() then
            ent:TakeDamage(1e9, ply, ply and ply:GetActiveWeapon() or Entity(0))
        end

        timer.Simple(0.1, function()
            if IsValid(ent) then
                ent:Remove()
            end
        end)
    end

    return true
end

function TOOL:LeftClick(trace)
    local ply = self:GetOwner()
    if DoBreak(trace, true, ply) then return true end

    return false
end

function TOOL:RightClick(trace)
    local ply = self:GetOwner()
    if DoBreak(trace, false, ply) then return true end

    return false
end

function TOOL:Reload()
end

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header", {
        Description = "#tool.breaker.desc"
    })
end
