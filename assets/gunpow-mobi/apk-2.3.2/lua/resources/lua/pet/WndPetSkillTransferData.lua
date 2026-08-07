--WndPetSkillTransferData.lua
--@brief	WndPetSkillTransfer的数据模块
--@date		2019/12/17
--@author	Tianxiang_Xu
--@note		宠物技能转移界面

WndPetSkillTransfer = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPetSkillTransfer:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nInterfaceIndex = 1 			--界面类型：1说明界面，2:列表界面，3:转移界面
	self.m_curPetInfo = nil 
	self.n_tCurSkillId = {}
	self.m_rightPetInfo = nil 			--被转移的宠物数据
	self.n_tRightSkillId = {}
	self.m_tSystemConfig = nil 
	self.petAni = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPetSkillTransfer:_unInit()
	self.m_root = nil
	self.m_nInterfaceIndex = nil
	self.m_curPetInfo = nil 
	self.n_tCurSkillId = nil 
	self.m_rightPetInfo = nil 			--被转移的宠物数据
	self.n_tRightSkillId = nil 
	self.m_tSystemConfig = nil 
	self.petAni = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPetSkillTransfer:createElement()
	if WndPetSkillTransfer.m_root ~= nil then
		WndPetSkillTransfer.m_root:removeFromParentAndCleanup(true)
	end
	local element = WZUISystem:getInstance():createElement("WndPetSkillTransfer")
	assert(element, "WndPetSkillTransfer create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndPetSkillTransfer:showInterface(curPetInfo)
	-- body
	local wndTransfer = WndPetSkillTransfer:createElement()
	if wndTransfer then 
		self.m_curPetInfo = curPetInfo
		WindowManager:addWindow(wndTransfer, WndPetSkillTransfer, nil, nil, nil, true)
	end
end

function WndPetSkillTransfer:setPetInfo(curPetInfo)
	self.m_curPetInfo = curPetInfo
end

--@brief 	转移成功
function WndPetSkillTransfer:transferSuccess()
	-- body
	if self.m_root == nil then return end 

	MsgBoxManager:showTipBox(LocalStrings.PETSKILL_TEXT6)
	
	-- WindowManager:removeWindow(self.m_root, self, true)
	-- WndPetSkillTransfer.m_root:removeFromParentAndCleanup(true)
	WndPetSkillTransfer:onCloseClick()
end

--@brief 	更新物品数量
function WndPetSkillTransfer:updatePlayerItemData()
	--body
	if self.m_root == nil then return end 

	if self.m_nInterfaceIndex == 3 then 
		self:_showTransferCost()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	获取可以转移的宠物列表
function WndPetSkillTransfer:getTransferPetList()
	-- body
	local pets =  CacheCenter:getPlayerPetInfo()
	local tPetlist = {}

	for i, petInfo in pairs(pets) do
	    WZLog("WndPets:setPetList111", i, petInfo.name, petInfo.fighting, tostring(petInfo.fighting ~= 0))
	    if petInfo.fighting ~= 0 and petInfo.advancedLevel >= 1 and petInfo.playerPetId ~= self.m_curPetInfo.playerPetId then
	        table.insert(tPetlist, petInfo)
	    end
	end

	table.sort(tPetlist, function (a, b)
		-- body
		if a.advancedLevel ~= b.advancedLevel then 
			return a.advancedLevel > b.advancedLevel
		else
			local qualityA = WndPetSkillTransfer:getpetQuality(a)
			local qualityB = WndPetSkillTransfer:getpetQuality(b)
			if qualityA ~= qualityB then 
				return qualityA > qualityB
			else
				if a.upgradeLevel ~= b.upgradeLevel then 
					return a.upgradeLevel > b.upgradeLevel
				else
					return a.itemId < b.itemId
				end
			end
		end
	end)

	return tPetlist 
end

function WndPetSkillTransfer:getpetQuality(petInfo)
	-- body
	return GDatatab_item["id_" .. petInfo.itemId].quality 
end


-------------------------------------私有方法模块End----------------------------------------
