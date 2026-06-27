
function TicksOnPoint(ticks, point)
	if ticks>0 and (ticks%point)==0 then
		return true
	else return false end
end

---¼ÓÑª
function AddHPBuff_Start(actor, def)
end

function AddHPBuff_End(actor, def)
end

function AddHPBuff_Update(actor, def, ticks)
	actor:addHP(def.AttrValues[0])
end

---ÔªËØ¹¥»÷
function DamageBuff_Start(actor, def)
end

function DamageBuff_End(actor, def)
end

function DamageBuff_Update(actor, def, ticks)
	actor:attackedByBuff(def.AttrValues[0], def.AttrValues[1]);
end