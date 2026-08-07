--WndHandBookData.lua
--@brief	WndHandBook的数据模块
--@date		2021/01/04
--@author	hyc
--@note		收集图鉴

WndHandBook = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHandBook:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurIndex = 1				--当前对应小标题界面
	self.m_nBigIndex = nil 				--当前对应大标题
	self.m_nCurUIId = nil				--功能对应id
	self.m_nListTag = 0
	self.m_tAllCardCell = nil 			--所有的图鉴item
	self.m_tFoot = nil 					--足迹
	self.m_tHorses = nil 				--坐骑
	self.m_tSkin = nil 					--皮肤
	self.m_haveGet = {} 				--已领取的图鉴
	-- self.m_skinStatus = nil 			--皮肤领取状态

end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHandBook:_unInit()
	self.m_root = nil
	self.m_nCurIndex = nil
	self.m_nBigIndex = nil 
	self.m_nCurUIId = nil
	self.m_nListTag = nil
	self.m_tAllCardCell = nil
	self.m_tFoot = nil
	self.m_tHorses = nil
	self.m_tSkin = nil
	self.m_haveGet = nil 
	-- self.m_skinStatus = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHandBook:createElement()
	WZLog("收集图鉴进来了")
	if WndHandBook.m_root ~= nil then
		WindowManager:removeWindow(WndHandBook.m_root, WndHandBook, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHandBook")
	assert(element, "WndHandBook create element failed!")
	self:_init()
	return element
end

function WndHandBook:showInterface(id)
	local mountsbook = WndHandBook:createElement()
	if mountsbook then
		self.m_nCurUIId = id
		WindowManager:addWindow(mountsbook,WndHandBook,false)
	end
end

function WndHandBook:GetRewardResult(itemId,num,rtype,id)
	-- body
	WZLog("WndHandBook:GetRewardResult",id, Serialize(itemId), Serialize(num)) 
	if rtype == 1 then
		for k,v in pairs(self.m_tHorses) do
			if v.id == id  then
				v.collectStatus = 2
				break
			end
		end
	elseif rtype == 2 then
		for k,v in pairs(self.m_tSkin) do
			local nameCur = GDatatab_shape_skins["id_" .. id].name
			local nameCompare = GDatatab_shape_skins["id_" .. v.id].name
			if v.id == id or nameCur == nameCompare then
				v.status = 2
				break
			end
		end
	elseif rtype == 3 then
		for k,v in pairs(self.m_tFoot) do
			if v.id == id then
				v.collectStatus = 2
				break 
			end
		end
	end

	if rtype == 1 then
		local bHaveRed = false 
		for k,v in pairs(self.m_tHorses) do
			if v.collectStatus == 1 then
				bHaveRed = true 
			 	break 
			end 
		end
		if not bHaveRed then 
			ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(270)
			WndPets:updatePartner()
			WndMounts:updatePartner()
		end
	elseif rtype == 2 then 
		local bHaveRed = false 
		for k,v in pairs(self.m_tSkin) do
			if v.status == 1 then
				bHaveRed = true
				break 
			end
		end
		if not bHaveRed then 
			ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(272)
			WndPets:updatePartner()
		end
	elseif rtype == 3 then 
		local bHaveRed = false 
		for k,v in pairs(self.m_tFoot) do
			if v.collectStatus == 1 then
				bHaveRed = true
				break 
			end
		end
		if not bHaveRed then 
			ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(271)
			WndPets:updatePartner()
		end
	end
	--刷新红点
	self:updateSmallItemReddot()

	WndRewardShow:showById(itemId,num)
	local tempList = {}
	tempList.rtype = rtype
	tempList.id = id
	table.insert(self.m_haveGet,tempList)
	WndHandBook:setBtnStatus(rtype,id)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	检查坐骑图鉴是否有红点
function WndHandBook:checkMountReddot()
	-- body
	local mountRed = {false, false, false, false}

	for j = 1,#self.m_tHorses do
		if self.m_tHorses[j].collectStatus == 1 then
			local index = GDatatab_mounts["id_"..self.m_tHorses[j].id].type
			local reward = GDatatab_mounts["id_"..self.m_tHorses[j].id].reward
			if index == 1 then mountRed[index] = true end
			if index == 2 then mountRed[index] = true end
			if index == 3 then mountRed[index] = true end
		end
	end

	return mountRed
end

--@brief 	检查足迹图鉴是否有红点
function WndHandBook:checkFootReddot()
	-- body
	local footRed = {false, false, false, false}

	for j = 1,#self.m_tFoot do
		if self.m_tFoot[j].collectStatus == 1 then
			local index = GDatatab_footmark["id_"..self.m_tFoot[j].id].type
			local reward = GDatatab_footmark["id_"..self.m_tFoot[j].id].reward
			if index == 1 and reward ~= -1 then footRed[index] = true end
			if index == 2 and reward ~= -1 then footRed[index] = true end
			if index == 3 and reward ~= -1 then footRed[index] = true end
		end	
	end

	return footRed
end

--@brief 	检查皮肤图鉴是否有红点
function WndHandBook:checkSkinReddot()
	-- body
	local skinRed = {false, false, false, false}

	for j = 1,#self.m_tSkin do
		if self.m_tSkin[j].status == 1 then
			local index = GDatatab_shape_skins["id_"..self.m_tSkin[j].id].type
			local reward = GDatatab_shape_skins["id_" .. self.m_tSkin[j].id].reward
			if reward == -1 then 
				reward = self:getSkinRealRewardParam(self.m_tSkin[j].id)
			end
			if index == 1 and reward ~= -1 then skinRed[index] = true end
			if index == 2 and reward ~= -1 then skinRed[index] = true end
			if index == 3 and reward ~= -1 then skinRed[index] = true end
			if index == 4 and reward ~= -1 then skinRed[index] = true end
		end
	end		

	return skinRed
end

--@brief 	根据id获取真实原始的皮肤reward字段数据
function WndHandBook:getSkinRealRewardParam(id)
	-- body
	local bFindParentId = false 
	local nFindId = id 
	local reward = GDatatab_shape_skins["id_" .. id].reward
	while nFindId ~= -1 do 
		bFindParentId = false 
		for i, value in pairs(GDatatab_shape_skins) do
			if value.next_shape ~= -1 and value.next_shape == nFindId then 
				nFindId = value.id
				bFindParentId = true 
				break 
			end
		end
		if not bFindParentId then 
			reward = GDatatab_shape_skins["id_" .. nFindId].reward
			nFindId = -1
		end
	end

	return reward
end
-------------------------------------私有方法模块End----------------------------------------
