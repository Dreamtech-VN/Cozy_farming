--WndWorldBossData.lua
--@brief	WndWorldBoss的数据模块
--@date		2015-9-24
--@author	binshao
--@note		一键继承窗口模块

WndWorldBoss = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWorldBoss:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_Id = nil 
	self.m_tEquipList = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWorldBoss:_unInit()
	self.m_root = nil
	self.m_Id = nil 
	self.m_tEquipList = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWorldBoss:createElement()
	local element = WZUISystem:getInstance():createElement("WndWorldBoss")
	assert(element, "WndWorldBoss create element failed!")
	self:_init()
	return element
end

function WndWorldBoss:showWnd(tEquipList, tNeedEquipId)
	local usingEquipList = CacheCenter:getEquipedList()
	local tTransferList = {}
	for i = 1, #tEquipList do
		local tItem = {}
		if tEquipList[i].basicInfo.main_type == 4 and tEquipList[i].basicInfo.time_limit == -1 then 
			for j = 1, #usingEquipList do
				if ((tEquipList[i].basicInfo.sub_type == 0 or tEquipList[i].basicInfo.sub_type == 1) and (usingEquipList[j].subtype == 0 or usingEquipList[j].subtype == 1)) or tEquipList[i].basicInfo.sub_type == usingEquipList[j].subtype then 
					if (usingEquipList[j].extraInfo.strongLevel > tEquipList[i].extraInfo.strongLevel and usingEquipList[j].extraInfo.starLevel >= tEquipList[i].extraInfo.starLevel) or (usingEquipList[j].extraInfo.strongLevel >= tEquipList[i].extraInfo.strongLevel and usingEquipList[j].extraInfo.starLevel > tEquipList[i].extraInfo.starLevel) then 
						if tEquipList[i].basicInfo.quality >= 1 and tEquipList[i].basicInfo.quality <= 3 and usingEquipList[j].basicInfo.quality >= 1 and usingEquipList[j].basicInfo.quality <= 3 then
							tItem[1] = CopyTable(usingEquipList[j])
							tItem[2] = CopyTable(tEquipList[i])

							table.insert(tTransferList, tItem)
							break 
						elseif (tEquipList[i].basicInfo.quality == 3 or tEquipList[i].basicInfo.quality == 4) and usingEquipList[j].basicInfo.quality == 4 then 
							tItem[1] = CopyTable(usingEquipList[j])
							tItem[2] = CopyTable(tEquipList[i])

							table.insert(tTransferList, tItem)
							break 
						end
					end
				end
			end
		end
	end
	if #tTransferList > 0 then 
		if self.m_root == nil then 
		    local wnd = WndWorldBoss:createElement()
		    if wnd then 
			    self.m_Id = VectorToTable(tNeedEquipId)
			    self.m_tEquipList = tTransferList
			    WindowManager:addWindow( wnd ,WndWorldBoss, false, nil, nil, true)
			end
		else
			local tIdTable = VectorToTable(tNeedEquipId)
			for i = 1, #tTransferList do
				local bIsExist = false 
				for j = 1, #self.m_tEquipList do
					if self.m_tEquipList[j][1].id == tTransferList[i][1].id then 
						bIsExist = true 
						self.m_tEquipList[j][2] = tTransferList[i][2]
						self.m_Id[j] = tIdTable[i]
						break 
					end
				end
				if not bIsExist then 
					table.insert(self.m_tEquipList, tTransferList[i])
					table.insert(self.m_Id, tIdTable[i])
				end
			end

			self:showEquipList() 
		end
	else
		local transferState = WZLuaVector_int_:create()
		for i = 1, tNeedEquipId:size() do
			transferState:push(0)
		end
		ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(tNeedEquipId, transferState)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------