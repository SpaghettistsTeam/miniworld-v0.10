

function getDifficultySetting()
	return 3
end

function getMobEnhanceFactor()
	return 0.75
end

--小鸡
function Chicken_OnTick(mob)
	if mob:isAdult() then
		mob:dropItem(2052, 1)
	end
end

--设置BreedingItem
function  InitBreedingItem()
	MobAddBreedingItem(3407, 2516)
	MobAddBreedingItem(3407, 2517)
	MobAddBreedingItem(3407, 2518)
	MobAddBreedingItem(3407, 2519)
	MobAddBreedingItem(3407, 2522)
	MobAddBreedingItem(3407, 2523)
	MobAddBreedingItem(3407, 2526)
	
	MobAddBreedingItem(3408, 2516)
	MobAddBreedingItem(3408, 2517)
	MobAddBreedingItem(3408, 2518)
	MobAddBreedingItem(3408, 2519)
	MobAddBreedingItem(3408, 2522)
	MobAddBreedingItem(3408, 2523)
	MobAddBreedingItem(3408, 2526)
	
	MobAddBreedingItem(3809, 2516)
	MobAddBreedingItem(3809, 2517)
	MobAddBreedingItem(3809, 2518)
	MobAddBreedingItem(3809, 2519)
	MobAddBreedingItem(3809, 2522)
	MobAddBreedingItem(3809, 2523)
	MobAddBreedingItem(3809, 2526)
	
	MobAddBreedingItem(3810, 2516)
	MobAddBreedingItem(3810, 2517)
	MobAddBreedingItem(3810, 2518)
	MobAddBreedingItem(3810, 2519)
	MobAddBreedingItem(3810, 2522)
	MobAddBreedingItem(3810, 2523)
	MobAddBreedingItem(3810, 2526)
	
	MobAddBreedingItem(3402, 236)
	MobAddBreedingItem(3811, 236)
	
	MobAddBreedingItem(3403, 229)
	MobAddBreedingItem(3814, 229)
	
	MobAddBreedingItem(3401, 229)
	MobAddBreedingItem(3812, 229)
	
	MobAddBreedingItem(3400, 1400)
	MobAddBreedingItem(3400, 1401)
	MobAddBreedingItem(3400, 1402)
	
	MobAddBreedingItem(3813, 1400)
	MobAddBreedingItem(3813, 1401)
	MobAddBreedingItem(3813, 1402)
end

--狼
function F3407_SetAi(actor)
	--寻路是否要避水
	actor:setAvoidWater(true)
	--驯服后取哪个mob的数值
	actor:setTamedID(3408)
	actor:setChildAdultID(3809)
	--参数 优先级，设置了这个ai表示会游泳
	actor:addAiTaskSwimming(1)
	actor:addAiTaskSit(2)
	actor:addAiLeapAtTarget(3, 40.0, 200, 400)
	--参数 优先级，被攻击对象的类型，是否追踪,速度因子
	actor:addAiTaskAtk(4, 0, true, 1.0)
	actor:addAiTaskFollowOwner(5, 1.0, 1000,200)
	actor:addAiMate(6, 1.0)
	actor:addAiTaskWander(7, 1.0)
	--参数 优先级，喜欢的食物，距离
	actor:addAiTaskBeg(8, 1302, 800)
	actor:addAiTaskWatchClosest(9, 600)
	actor:addAiTaskLookIdle(9)
	actor:addAiTaskTargetOnwnerHurtee(1)
	actor:addAiTaskTargetOnwnerHurter(2)
	actor:addAiTaskTargetHurtee(3, true)
	--参数  优先级，未驯服时攻击的怪物id，概率
	actor:addAiTaskTargetNonTamed(4, 3403, 200)
end

function  F3407_CreateChild(actor1, actor2, child)
	if actor1:getTamed() then
		child:setTamedOwnerUin(actor1:getTamedOwnerID() , false)
		--child:setChildAdultID(3407)
	end
end

function F3407_Interact(mob, player)
	local itemid = player:getCurToolID()
	if mob:getTamed() then
		if itemid ~= 0 then
			if mob:isBreedItem(itemid) and mob:getAttrib():getHP() < mob:getAttrib():getMaxHP()  then
				mob:getAttrib():addHP(DefMgr:getFoodDef(itemid).HealAmount)
				CurMainPlayer:shortcutItemUsed()
				return  true
			elseif 	itemid >= 1500 and itemid <= 1514  then
				color = itemid - 1500
				if mob:getCollarColor() ~= color  then
					CurMainPlayer:shortcutItemUsed()
					mob:setCollarColor(color)
					return true
				end
			end
		end
		
		if  mob:getTamedOwnerID() == player:getUin() and (not mob:isBreedItem(itemid))  then
			mob:setAISitting(not mob:getSitting())
			return true
		end
	elseif itemid == 1302 and (not mob:getAngry())  then	
		CurMainPlayer:shortcutItemUsed()
		if math.random(0,2) == 0  then
			mob:mobTamed(player:getUin())
		else	
			mob:playTameEffect(false)
		end
		
		return true
	end
	
	return false
end	

--小狼
function F3809_SetAi(actor)
	--寻路是否要避水
	actor:setAvoidWater(true)
	--驯服后取哪个mob的数值
	actor:setTamedID(3810)
	actor:setGrowingAge(-24000)
	actor:setChildAdultID(3407)
	--参数 优先级，设置了这个ai表示会游泳
	actor:addAiTaskSwimming(1)
	actor:addAiTaskSit(2)
	actor:addAiLeapAtTarget(3, 40.0, 200, 400)
	--参数 优先级，被攻击对象的类型，是否追踪,速度因子
	actor:addAiTaskAtk(4, 0, true, 1.0)
	actor:addAiTaskFollowOwner(5, 1.0, 1000,200)
	actor:addAiMate(6, 1.0)
	actor:addAiTaskWander(7, 1.0)
	--参数 优先级，喜欢的食物，距离
	actor:addAiTaskBeg(8, 1302, 800)
	actor:addAiTaskWatchClosest(9, 600)
	actor:addAiTaskLookIdle(9)
	actor:addAiTaskTargetOnwnerHurtee(1)
	actor:addAiTaskTargetOnwnerHurter(2)
	actor:addAiTaskTargetHurtee(3, true)
	--参数  优先级，未驯服时攻击的怪物id，概率
	actor:addAiTaskTargetNonTamed(4, 3403, 200)
end

function F3809_Interact(mob, player)
	local itemid = player:getCurToolID()
	if mob:getTamed() then
		if itemid ~= 0 then
			if mob:isBreedItem(itemid) and mob:getAttrib():getHP() < mob:getAttrib():getMaxHP()  then
				mob:getAttrib():addHP(DefMgr:getFoodDef(itemid).HealAmount)
				CurMainPlayer:shortcutItemUsed()
				return  true
			elseif 	itemid >= 1500 and itemid <= 1514  then
				color = itemid - 1500
				if mob:getCollarColor() ~= color  then
					CurMainPlayer:shortcutItemUsed()
					mob:setCollarColor(color)
					return true
				end
			end
		end
		
		if  mob:getTamedOwnerID() == player:getUin() and (not mob:isBreedItem(itemid))  then
			mob:setAISitting(not mob:getSitting())
			return true
		end
	elseif itemid == 1302 and (not mob:getAngry())  then	
		CurMainPlayer:shortcutItemUsed()
		if math.random(0,2) == 0  then
			mob:mobTamed(player:getUin())
		else	
			mob:playTameEffect(false)
		end
		
		return true
	end
	
	return false
end	


--狗
function F3408_SetAi(actor)
--寻路是否要避水
	actor:setAvoidWater(true)
	actor:setChildAdultID(3810)
	--参数 优先级，设置了这个ai表示会游泳
	actor:addAiTaskSwimming(1)
	actor:addAiTaskSit(2)
	actor:addAiLeapAtTarget(3, 40.0, 200, 400)
	--参数 优先级，被攻击对象的类型，是否追踪,速度因子
	actor:addAiTaskAtk(4, 0, true, 1.0)
	actor:addAiTaskFollowOwner(5, 1.0, 1000,200)
	actor:addAiMate(6, 1.0)
	actor:addAiTaskWander(7, 1.0)
	--参数 优先级，喜欢的食物，距离
	actor:addAiTaskBeg(8, 1302, 800)
	actor:addAiTaskWatchClosest(9, 600)
	actor:addAiTaskLookIdle(9)
	actor:addAiTaskTargetOnwnerHurtee(1)
	actor:addAiTaskTargetOnwnerHurter(2)
	actor:addAiTaskTargetHurtee(3, true)
end

function  F3408_CreateChild(actor1, actor2, child)
	if actor1:getTamed() then
		child:setTamedOwnerUin(actor1:getTamedOwnerID() , false)
		--child:setChildAdultID(3408)
	end
end

function F3408_Interact(mob, player)
	local itemid = player:getCurToolID()
	if mob:getTamed() then
		if itemid ~= 0 then
			if mob:isBreedItem(itemid) and mob:getAttrib():getHP() < mob:getAttrib():getMaxHP()  then
				mob:getAttrib():addHP(DefMgr:getFoodDef(itemid).HealAmount)
				CurMainPlayer:shortcutItemUsed()
				return  true
			elseif 	itemid >= 1500 and itemid <= 1514  then
				color = itemid - 1500
				if mob:getCollarColor() ~= color  then
					CurMainPlayer:shortcutItemUsed()
					mob:setCollarColor(color)
					return true
				end
			end
		end
		if  mob:getTamedOwnerID() == player:getUin() and (not mob:isBreedItem(itemid))  then
			mob:setAISitting(not mob:getSitting())
			return true
		end
	elseif itemid == 1302 and (not mob:getAngry())  then	
		CurMainPlayer:shortcutItemUsed()
		if math.random(0,2) == 0  then
			mob:mobTamed(player:getUin())
		else	
			mob:playTameEffect(false)
		end
		
		return true
	end
	
	return false
end	

--小狗
function F3810_SetAi(actor)
	--寻路是否要避水
	actor:setAvoidWater(true)
	actor:setChildAdultID(3408)
	actor:setGrowingAge(-24000)
	--参数 优先级，设置了这个ai表示会游泳
	actor:addAiTaskSwimming(1)
	actor:addAiTaskSit(2)
	actor:addAiLeapAtTarget(3, 0.4, 200, 400)
	--参数 优先级，被攻击对象的类型，是否追踪,速度因子
	actor:addAiTaskAtk(4, 0, true, 1.0)
	actor:addAiTaskFollowOwner(5, 1.0, 1000,200)
	actor:addAiMate(6, 1.0)
	actor:addAiTaskWander(7, 1.0)
	--参数 优先级，喜欢的食物，距离
	actor:addAiTaskBeg(8, 1302, 800)
	actor:addAiTaskWatchClosest(9, 600)
	actor:addAiTaskLookIdle(9)
	actor:addAiTaskTargetOnwnerHurtee(1)
	actor:addAiTaskTargetOnwnerHurter(2)
	actor:addAiTaskTargetHurtee(3, true)
end

function F3810_Interact(mob, player)
	local itemid = player:getCurToolID()
	if mob:getTamed() then
		if itemid ~= 0 then
			if mob:isBreedItem(itemid) and mob:getAttrib():getHP() < mob:getAttrib():getMaxHP()  then
				mob:getAttrib():addHP(DefMgr:getFoodDef(itemid).HealAmount)
				CurMainPlayer:shortcutItemUsed()
				return  true
			elseif 	itemid >= 1500 and itemid <= 1514  then
				color = itemid - 1500
				if mob:getCollarColor() ~= color  then
					CurMainPlayer:shortcutItemUsed()
					mob:setCollarColor(color)
					return true
				end
			end
		end
		if  mob:getTamedOwnerID() == player:getUin() and (not mob:isBreedItem(itemid))  then
			mob:setAISitting(not mob:getSitting())
			return true
		end
	elseif itemid == 1302 and (not mob:getAngry())  then	
		CurMainPlayer:shortcutItemUsed()
		if math.random(0,2) == 0  then
			mob:mobTamed(player:getUin())
		else	
			mob:playTameEffect(false)
		end
		
		return true
	end
	
	return false
end	

--猪
function F3402_SetAi(actor)
	actor:setChildAdultID(3811)
	actor:setAvoidWater(true)
	actor:addAiTaskSwimming(0)
	actor:addAiTaskPanic(1, 1.25)
	actor:addAiMate(3, 1.0)
	actor:addAiTaskTempt(4, 1.2, 236, false)
	actor:addAiTaskFollowParent(5, 1.1)
	actor:addAiTaskWander(6, 1.0)
	actor:addAiTaskWatchClosest(7, 600)
	actor:addAiTaskLookIdle(8)
end

--小猪
function F3811_SetAi(actor)
	actor:setChildAdultID(3402)
	actor:setGrowingAge(-24000)
	actor:setAvoidWater(true)
	actor:addAiTaskSwimming(0)
	actor:addAiTaskPanic(1, 1.25)
	actor:addAiMate(3, 1.0)
	actor:addAiTaskTempt(4, 1.2, 236, false)
	actor:addAiTaskFollowParent(5, 1.1)
	actor:addAiTaskWander(6, 1.0)
	actor:addAiTaskWatchClosest(7, 600)
	actor:addAiTaskLookIdle(8)
end

--骷髅
function F3105_SetAi(actor)
	actor:setSunHurt(true)
	actor:addAiTaskSwimming(1)
	actor:addAiTaskRestrictSun(2)
	actor:addAiTaskFleeSun(3, 1.0)
	actor:addAiTaskArrowAttack(4, 1.0, 20, 60, 1500)
	actor:addAiTaskWander(5, 1.0)
	actor:addAiTaskWatchClosest(6, 800)
	actor:addAiTaskLookIdle(6)
	actor:addAiTaskTargetHurtee(1, false)
	--参数  优先级，概率 0表示忽略，是否检查可见
	actor:addAiTaskTargetNearest(2, 0, true, 0.0)
end

--僵尸
function F3101_SetAi(actor)
	actor:setSunHurt(true)
	actor:setChildAdultID(3102)
	actor:setCanPassClosedWoodenDoors(true)
	actor:addAiTaskSwimming(0)
	actor:addAiTaskBreakDoor(1)
	actor:addAiTaskAtk(2, 0, false, 1.0)
	--actor:addAiTaskMoveTowardsRestriction(4, 1.0)
	actor:addAiTaskWander(6, 1.0)
	actor:addAiTaskWatchClosest(7, 800)
	actor:addAiTaskLookIdle(7)
	actor:addAiTaskTargetHurtee(1, true)
	actor:addAiTaskTargetNearest(2, 0, true, 0.0)
end

function F3101_AttackEntityAsMob(mob, actor)
	if mob:getEquipIDByIdx(0) == 0 and mob:isBurning() and GenRandomFloat() < getDifficultySetting()*0.3 then
		actor:setFire(2 * getDifficultySetting())
	end
	
	return true;
end

function MobAddRandomEquipments(mob)
	if math.random() < 0.015 * getMobEnhanceFactor() then
		quality = math.random(0, 1)
		if math.random() < 0.095 then quality = quality + 1 end
		if math.random() < 0.095 then quality = quality + 1 end
		if math.random() < 0.095 then quality = quality + 1 end

		local factor2 = 0.25
		for slot=0, 4, 1 do
			if slot>0 and math.random()<factor2 then break end

			local itemid = 2200 + quality*10 + slot + 1
			mob:setEquipIDByIdx(slot, itemid)
		end
	end

	mob:enchantEquipment()
end

function F3101_Init(mob)
	mob:setCanPickUpLoot(true)
	MobAddRandomEquipments(mob)

	local factor = 0.01
	if math.random() < factor then
		if math.random(0,2) == 0 then
			mob:setEquipIDByIdx(5, 2003) --铁剑
		else
			mob:setEquipIDByIdx(5, 1023) --铁铲
		end
	end
end

--小僵尸
function F3102_SetAi(actor)
	actor:setSunHurt(true)
	actor:setChildAdultID(3101)
	actor:setCanPassClosedWoodenDoors(true)
	actor:addAiTaskSwimming(0)
	actor:addAiTaskBreakDoor(1)
	actor:addAiTaskAtk(2, 0, false, 1.0)
	--actor:addAiTaskMoveTowardsRestriction(4, 1.0)
	actor:addAiTaskWander(6, 1.0)
	actor:addAiTaskWatchClosest(7, 800)
	actor:addAiTaskLookIdle(7)
	actor:addAiTaskTargetHurtee(1, true)
	actor:addAiTaskTargetNearest(2, 0, true, 0.0)
end

function F3102_AttackEntityAsMob(mob, actor)
	if mob:getEquipIDByIdx(0) == 0 and mob:isBurning() then
		actor:setFire(6)
	end
	
	return true;
end

function F3102_Init(mob)
	mob:setCanPickUpLoot(true)
	if math.random(0, 3) == 0 then
		mob:setEquipIDByIdx(0, 2003)
	else
		mob:setEquipIDByIdx(0, 1023)
	end
	
	mob:enchantEquipment()
	
	if math.random(0, 4) == 0 then
		if math.random(0, 10) == 0  then
			mob:setEquipIDByIdx(4, 816)
		else
			mob:setEquipIDByIdx(4, 230)
		end
	end
end

--jj怪
function F3109_SetAi(actor)
	actor:setPathHide(1)
	actor:addAiTaskSwimming(1)
	actor:addAiTaskCreeperSwell(2)
	actor:addAiTaskAtk(4, 0, false, 1.0)
	actor:addAiTaskWander(5, 0.8)
	actor:addAiTaskWatchClosest(6, 800)
	actor:addAiTaskLookIdle(6)
	actor:addAiTaskTargetNearest(1, 0, true, 0.0)
	actor:addAiTaskTargetHurtee(2, false)
end

function F3109_AttackEntityAsMob(mob, actor)
	return false;
end

function F3109_OnFall(mob, fall)
	local time = mob:getTimeSinceIgnited() + fall*1.5
	if time > 30 - 5  then
		time = 30 - 5
	end
	
	mob:setTimeSinceIgnited(time)
	
	return true
end

--蜘蛛
function F3107_SetAi(actor)
	actor:addAiTaskSwimming(1)
	actor:addAiLeapAtTarget(2, 40.0, 200, 600)
	actor:addAiTaskAtk(3, 0, false, 1.0)
	actor:addAiTaskWander(4, 0.8)
	actor:addAiTaskWatchClosest(5, 800)
	actor:addAiTaskLookIdle(6)
	actor:addAiTaskTargetNearest(1, 0, true, 0.5)
	actor:addAiTaskTargetHurtee(2, false)
end

function  F3107_IsPotionApplicable(buffid)
	if buffid == 6 then
		return false
	end
	
	return true		
end

--洞穴蜘蛛
function F3108_SetAi(actor)
	actor:addAiTaskSwimming(1)
	actor:addAiLeapAtTarget(2, 40.0, 200, 600)
	actor:addAiTaskAtk(3, 0, false, 1.0)
	actor:addAiTaskWander(4, 0.8)
	actor:addAiTaskWatchClosest(5, 800)
	actor:addAiTaskLookIdle(6)
	actor:addAiTaskTargetNearest(1, 0, true, 0.5)
	actor:addAiTaskTargetHurtee(2, false)
end

function  F3108_IsPotionApplicable(buffid)
	if buffid == 6 then
		return false
	end
	
	return true		
end

function F3108_AttackEntityAsMob(mob, actor)
	actor:addBuff(6, 1)
	return true;
end

--牛
function F3401_SetAi(actor)
	actor:setChildAdultID(3812)
	actor:setAvoidWater(true)
	actor:addAiTaskSwimming(0)
	actor:addAiTaskPanic(1, 2.0)
	actor:addAiMate(2, 1.0)
	actor:addAiTaskTempt(3, 1.25, 229, false)
	actor:addAiTaskFollowParent(4, 1.25)
	actor:addAiTaskWander(5, 1.0)
	actor:addAiTaskWatchClosest(6, 600)
	actor:addAiTaskLookIdle(7)
end

function F3401_Interact(mob, player)
	local itemid = player:getCurToolID()
	if  itemid == 1050 then
		CurMainPlayer:shortcutItemUsed()
		local num = player:getBackPack():addItem(2509, 1)
		if num ~= 1 then
			player:dropItem(2509, 1)
		end
		return true
	end
	
	return false
end

--小牛
function F3812_SetAi(actor)
	actor:setChildAdultID(3401)
	actor:setGrowingAge(-24000)
	actor:setAvoidWater(true)
	actor:addAiTaskSwimming(0)
	actor:addAiTaskPanic(1, 2.0)
	actor:addAiMate(2, 1.0)
	actor:addAiTaskTempt(3, 1.25, 229, false)
	actor:addAiTaskFollowParent(4, 1.25)
	actor:addAiTaskWander(5, 1.0)
	actor:addAiTaskWatchClosest(6, 600)
	actor:addAiTaskLookIdle(7)
end

function F3812_Interact(mob, player)
	local itemid = player:getCurToolID()
	if  itemid == 1050 then
		CurMainPlayer:shortcutItemUsed()
		local num = player:getBackPack():addItem(2509, 1)
		if num ~= 1 then
			player:dropItem(2509, 1)
		end
		return true
	end
	
	return false
end


--鸡
function F3400_SetAi(actor)
	actor:setChildAdultID(3813)
	actor:setCanFly(true)
	actor:addAiTaskSwimming(0)
	actor:addAiTaskPanic(1, 1.4)
	actor:addAiMate(2, 1.0)
	--引诱，参数  优先级，速度因子，种子id，是否会被角色移动惊吓
	actor:addAiTaskTempt(3, 1.0, 1400, false)
	actor:addAiTaskFollowParent(4, 1.1)
	actor:addAiTaskWander(5, 1.0)
	actor:addAiTaskWatchClosest(6, 600)
	actor:addAiTaskLookIdle(7)
end

function F3400_OnFall(mob, fall)
	return false
end

--小鸡
function F3813_SetAi(actor)
	actor:setChildAdultID(3400)
	actor:setCanFly(true)
	actor:setGrowingAge(-24000)
	actor:addAiTaskSwimming(0)
	actor:addAiTaskPanic(1, 1.4)
	actor:addAiMate(2, 1.0)
	actor:addAiTaskTempt(3, 1.0, 1400, false)
	actor:addAiTaskFollowParent(4, 1.1)
	actor:addAiTaskWander(5, 1.0)
	actor:addAiTaskWatchClosest(6, 600)
	actor:addAiTaskLookIdle(7)
end

function F3813_OnFall(mob, fall)
	return false
end

--羊
function F3403_Interact(mob, player)
	local itemid = player:getCurToolID()
	if itemid == 1056 and not mob:getSheared() then
		c = mob:getColor()
		local dropid
		if c < 0 then dropid = 600
		else dropid = 600 + c end

		local dropnum = 1
		mob:dropItem(dropid, dropnum)
		
		mob:setSheared(true)
		return true
	elseif itemid>=1501 and itemid<=1514 then
		mob:setColor(itemid-1500)
	end
	
	return false
end	

function F3403_Init(mob)
	local rand = math.random(0, 100)
	if rand < 5 then
		mob:setColor(15)
	elseif rand < 10 then
		mob:setColor(7)	
	elseif rand < 15 then
		mob:setColor(8)
	elseif rand < 18 then	
		mob:setColor(12)
	else
		if  0 == math.random(0, 500) then
			mob:setColor(6)
		else
			mob:setColor(0)
		end
	end
	
end

function F3403_SetAi(actor)
	actor:setAvoidWater(true)
	actor:addAiTaskSwimming(0)
	actor:addAiTaskPanic(1, 1.25)
	actor:addAiMate(2, 1.0)
	actor:addAiTaskTempt(4, 1.1, 229, false)
	actor:addAiTaskEatGrass(6)
	actor:addAiTaskWander(7, 1.0)
	actor:addAiTaskWatchClosest(8, 600)
	actor:addAiTaskLookIdle(9)
end

--小羊
function F3814_Init(mob)
	local rand = math.random(0, 100)
	if rand < 5 then
		mob:setColor(15)
	elseif rand < 10 then
		mob:setColor(7)	
	elseif rand < 15 then
		mob:setColor(8)
	elseif rand < 18 then	
		mob:setColor(12)
	else
		if  0 == math.random(0, 500) then
			mob:setColor(6)
		else
			mob:setColor(0)
		end
	end
	
end

function F3814_SetAi(actor)
	actor:setGrowingAge(-24000)
	actor:setChildAdultID(3403)
	actor:setAvoidWater(true)
	actor:addAiTaskSwimming(0)
	actor:addAiTaskPanic(1, 1.25)
	actor:addAiMate(2, 1.0)
	actor:addAiTaskTempt(4, 1.1, 229, false)
	actor:addAiTaskFollowParent(5, 1.1)
	actor:addAiTaskEatGrass(6)
	actor:addAiTaskWander(7, 1.0)
	actor:addAiTaskWatchClosest(8, 600)
	actor:addAiTaskLookIdle(9)
end

--末影人
function F3501_Init(mob)
end

function F3501_SetAi(actor)
	actor:addAiTaskAtk(1, 0, false, 1.0)
	actor:addAiTaskWander(2, 1.0)
	actor:addAiTaskLookIdle(3)
end

--女巫
function F3121_SetAi(actor)
	actor:addAiTaskSwimming(1)
	--actor:addAiArrowAttack
	actor:addAiTaskWander(2, 1.0)
	actor:addAiTaskWatchClosest(3, 600)
	actor:addAiTaskLookIdle(3)
	actor:addAiTaskTargetHurtee(1, false)
	actor:addAiTaskTargetNearest(2, 0, true, 0.0)
end

--僵尸
function F3130_SetAi(actor)
	actor:setCanPassClosedWoodenDoors(true)
	actor:addAiTaskSwimming(0)
	actor:addAiTaskBreakDoor(1)
	actor:addAiTaskAtk(2, 0, false, 1.0)
	--actor:addAiTaskMoveTowardsRestriction(4, 1.0)
	actor:addAiTaskWander(6, 1.0)
	actor:addAiTaskWatchClosest(7, 800)
	actor:addAiTaskLookIdle(7)
	actor:addAiTaskTargetHurtee(1, true)
	actor:addAiTaskTargetNearest(2, 0, true, 0.0)
end

--硫磺骨弓
function F3131_SetAi(actor)
	actor:addAiTaskSwimming(1)
	actor:addAiTaskRestrictSun(2)
	actor:addAiTaskFleeSun(3, 1.0)
	actor:addAiTaskArrowAttack(4, 1.0, 20, 60, 1500)
	actor:addAiTaskWander(5, 1.0)
	actor:addAiTaskWatchClosest(6, 800)
	actor:addAiTaskLookIdle(6)
	actor:addAiTaskTargetHurtee(1, false)
	--参数  优先级，概率 0表示忽略，是否检查可见
	actor:addAiTaskTargetNearest(2, 0, true, 0.0)
end