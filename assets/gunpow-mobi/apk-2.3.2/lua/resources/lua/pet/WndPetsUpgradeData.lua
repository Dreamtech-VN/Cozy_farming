--WndPetsUpgradeData.lua
--@brief	WndPetsUpgrade的数据模块
--@date		2015/03/31
--@author	qixiang_xie
--@note		宠物升级

WndPetsUpgrade = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPetsUpgrade:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_petInfo = {}                 --宠物信息
	self.m_iCostType = nil              --需要花费的资源类型
	self.m_bIsAlter = false             
	self.m_tPets = {}                   --存放被吃的宠物
	self.m_tMatchPets = {}              --存放符合升级吞噬的宠物
	self.m_tMatchList = {}				--存放列表
	self.n_curExp = 0 					--当前经验
	self.n_addExp = 0  					--增加经验
	self.n_nextExp = 0 					--下一集的经验
	self.m_iCostType = 0                --消费类型
	self.n_curLv = 0                    --当前等级
	self.n_choiceNum = 0                --已选个数
	self.m_tUsePet = {}                 --记录格子里的宠物
	self.b_eatPet = false               --是否处于添加宠物界面
	self.b_Up = false                   --是否属于升级状态
	self.m_nMaxNum = 16
	self.m_tTempEatPet = nil 
	self.petAni = nil                   --宠物动画
	self.n_whileLv = 0 					--将达到的等级
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPetsUpgrade:_unInit()
	self.m_root = nil
	self.m_petInfo = nil
	self.m_iCostType = nil
	self.m_tPets = nil
	self.m_bIsAlter = nil      
	self.m_tMatchPets = nil
	self.m_tMatchList = nil			
	self.n_curExp = nil 					
	self.n_addExp = nil  					
	self.n_nextExp = nil
	self.m_iCostType = nil
	self.n_curLv = nil
	self.n_choiceNum = nil
	self.m_tUsePet =nil
	self.b_eatPet = nil	
	self.b_Up = nil
	self.m_nMaxNum = nil
	self.m_tTempEatPet = nil 
	self.petAni = nil
	self.n_whileLv = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPetsUpgrade:createElement()
	if WndPetsUpgrade.m_root ~= nil then
		WndPetsUpgrade.m_root:removeFromParentAndCleanup(true)
	end
	local element = WZUISystem:getInstance():createElement("WndPetsUpgrade")
	assert(element, "WndPetsUpgrade create element failed!")
	self:_init()
	return element
end

--@brief   设置宠物信息
function WndPetsUpgrade:setPetInfo(petInfo)
	WZLog("WndPetsUpgrade:setPetInfo")
	if petInfo ~= nil then
		self.m_petInfo = petInfo
		WZLog("WndPetsUpgrade:setPetInfo:",petInfo.fighting)
	end
end

--@brief   更新宠物信息
function WndPetsUpgrade:updatePetInfo(petInfo)
	self.m_petInfo = petInfo
end

--设置宠物升级经验的相关信息
function WndPetsUpgrade:setPetExpInfo(petInfo)
	if not petInfo then return end
	self.n_curLv = petInfo.upgradeLevel
	self.n_whileLv = petInfo.upgradeLevel
	self.n_curExp = petInfo.petExp
	local paleyLv =  math.min(CacheCenter:getPlayerInfo().level, tonumber(CacheCenter:getGameParam().gameMaxLevel))
	--从当前宠物等级到角色玩家等级锁需要的经验
	if petInfo.itemId then
		local quality = GDatatab_item["id_"..petInfo.itemId].quality
		local hasExp = 0
		if  self.n_curLv == 1 then
			hasExp = 0 + self.n_curExp
		else
			local id = self.n_curLv - 1
			hasExp = self:_getTotalExp(id, quality).total_exp + self.n_curExp
		end				
		self.n_nextExp = math.max(self:_getTotalExp(paleyLv-1, quality).total_exp - hasExp, 0)
		WZLog("WndPetsUpgrade:setPetExpInfo:", self:_getTotalExp(paleyLv, quality).total_exp, hasExp,self.n_curExp, self.n_nextExp)
		self.m_iCostType = 	self:_getTotalExp(petInfo.upgradeLevel, quality).cost[1][1]
	end
end 
-------------------------------------公有方法模块End----------------------------------------


function WndPetsUpgrade:_getTotalExp(level, quality)
	for  k,v in pairs(GDatatab_pet_upgrade) do
      if v.quality == quality and v.level ==  level then
      		WZLog("WndPetsUpgrade:_getTotalExp(:",v.total_exp)
          return v
      end
    end
    return {total_exp=999999999999}
end

-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndPetsUpgrade:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief 	判断剩余的可吞噬的宠物，是否足够进行下一级
function WndPetsUpgrade:_judgeEnoughPetForNextLevel()
	-- body
	local addLevel = GetElement(self.m_root, "txtPetEPD2_WndPetsUpgrade", WZUILabelTTF):getText()
    local petLv = self.n_curLv + addLevel
    local quality = GDatatab_item["id_"..self.m_petInfo.itemId].quality

    local totalExp = self:_getTotalExp(petLv, quality).total_exp
    local nowExp = 0
    if self.n_curLv == 1 then 
        nowExp = self.n_curExp
    else
        nowExp = self:_getTotalExp(self.n_curLv - 1, quality).total_exp + self.n_curExp 
    end
    local needExp = totalExp - nowExp - self.n_addExp
    local bEnoughForUp = false 
    WZLog("WndPetsUpgrade:_judgeEnoughPetForNextLevel", totalExp, needExp, nowExp, self.n_addExp)
    if needExp > 0 then 
	    for i =1,#self.m_tMatchList do
	        if self.m_tMatchList[i].m_tData.itemId == 11007 or self.m_tMatchList[i].m_tData.itemId == 11000 then
	            --已选择的数量
	            local chooseNum = self.m_tMatchList[i]:getChooseNum()
	            --剩余数量
	            local leftNum = self.m_tMatchList[i].num - chooseNum 
	            WZLog("WndPetsUpgrade:_judgeEnoughPetForNextLevel", leftNum)
	            if leftNum > 0 then 
	                local nOtherValue = self:getExpPetExp(self.m_tMatchList[i].m_tData)
	                for k = 1, leftNum do
	                    needExp = needExp - nOtherValue 
	                    if needExp <= 0 then 
	                        bEnoughForUp = true
	                        break 
	                    end
	                end
	                if bEnoughForUp then 
	                    break 
	                end
	            end
	        else
	            local nOtherValue = self:getExpPetExp(self.m_tMatchList[i].m_tData)
                needExp = needExp - nOtherValue 
                if needExp <= 0 then 
                	bEnoughForUp = true
                    break
                end
	        end 
	    end
	end

	return bEnoughForUp
end

--@brief 	获取选择经验宠物的上限数量
function WndPetsUpgrade:getNeedMaxExpPetNum(itemId)
	-- body
	local addLevel = GetElement(self.m_root, "txtPetEPD2_WndPetsUpgrade", WZUILabelTTF):getText()
    local petLv = CacheCenter:getPlayerInfo().level
    local quality = GDatatab_item["id_"..self.m_petInfo.itemId].quality

    local totalExp = self:_getTotalExp(petLv, quality).total_exp - 10
    local nowExp = 0
    if self.n_curLv == 1 then 
        nowExp = self.n_curExp
    else
        nowExp = self:_getTotalExp(self.n_curLv - 1, quality).total_exp + self.n_curExp 
    end
    local needExp = totalExp - nowExp - self.n_addExp
    local nMxNum = 0 
    local leftNum = 0
    WZLog("WndPetsUpgrade:_judgeEnoughPetForNextLevel", totalExp, needExp, nowExp, self.n_addExp)
    if needExp > 0 then 
	    for i =1,#self.m_tMatchList do
	        if self.m_tMatchList[i].m_tData.itemId == itemId then
	            --已选择的数量
	            local nOtherValue = self:getExpPetExp(self.m_tMatchList[i].m_tData)
	            local chooseNum = self.m_tMatchList[i]:getChooseNum()
	            --剩余数量
	            leftNum = self.m_tMatchList[i].num - chooseNum 
	            nMxNum = math.floor(needExp/nOtherValue)
	            break 
	        end 
	    end
	end

	return math.min(nMxNum, leftNum)
end

--@brief 	获取是否超出玩家等级
function WndPetsUpgrade:judgeLargerThanPlayer()
	--body
	if self.m_root == nil then return false end 

	local addLevel = GetElement(self.m_root, "txtPetEPD2_WndPetsUpgrade", WZUILabelTTF):getText()
    local petLv = self.n_curLv + addLevel
	local playerLv = CacheCenter:getPlayerInfo().level
    if playerLv <= petLv then
        MsgBoxManager:showTipBox(LocalStrings.PETUPTOLEVEL)
        return true
    end

    return false 
end
-------------------------------------私有方法模块End----------------------------------------
