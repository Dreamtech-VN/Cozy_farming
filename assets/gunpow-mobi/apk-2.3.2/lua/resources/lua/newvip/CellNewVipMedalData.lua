--CellNewVipMedalData.lua
--@brief	CellNewVipMedal的数据模块
--@date		2021/03/22
--@author	hyx
--@note		贵族勋章

CellNewVipMedal = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellNewVipMedal:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tMedalData = {}
	self.m_sLevelRewardItem = nil
	self.m_tAllRewardData = {}
	self.m_tCurRewardData = nil 		--当前可领取的等级奖励
	self.m_nCurLevel = nil 
	self.m_nCurPoint = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewVipMedal:_unInit()
	self.m_root = nil
	self.m_tMedalData = {}
	self.m_sLevelRewardItem = nil
	self.m_tAllRewardData = {}
	self.m_tCurRewardData = nil 		--当前可领取的等级奖励
	self.m_nCurLevel = nil 
	self.m_nCurPoint = nil 
end

--获取勋章的数据
function CellNewVipMedal:setMedalData()
	if GDatatab_vip_medal_stage then
		for i,v in pairs(GDatatab_vip_medal_stage) do
			if self.m_tMedalData[v.type] == nil then
				self.m_tMedalData[v.type] = {}
			end
			if self.m_tMedalData[v.type][1] == nil then
				table.insert(self.m_tMedalData[v.type],v)
			else
				if self.m_tMedalData[v.type][1].type == v.type then
					table.insert(self.m_tMedalData[v.type],v)
				end
			end
		end
	end

	for i, value in pairs(self.m_tMedalData) do
		table.sort(value, function (a,b)
			-- body
			return a.stage < b.stage 
		end)
	end
end
--所有奖励的数据
function CellNewVipMedal:setAllGetReward(levelIds, levelRewardStatus)
	if GDatatab_vip_medal_level then
		for i,v in pairs(GDatatab_vip_medal_level) do
			v.status = -1
			table.insert(self.m_tAllRewardData,v)
		end
		table.sort(self.m_tAllRewardData,function(a,b) return a.level < b.level end)
		--0可领取 1已领取
		for i=1, #levelIds do
			self.m_tAllRewardData[levelIds[i]].status = levelRewardStatus[i]
		end
	end
end
--领取之后改变状态
function CellNewVipMedal:setChangeRewardStatus(id)
	for i=1,#self.m_tAllRewardData do
		if self.m_tAllRewardData[i].id == id then
			self.m_tAllRewardData[i].status = 1
			break
		end
	end
end

function CellNewVipMedal:onGetRewardResult(result, medalLevelId, rewardItemIds, rewardItemNums)
	if self.m_root == nil then return end 

	if result == 1 then
		WndRewardShow:showById(rewardItemIds, rewardItemNums)
		self:setChangeRewardStatus(medalLevelId)
		self:setMedalLevelData(self.m_nCurLevel, self.m_nCurPoint)
	elseif result == 2 then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
	elseif result == 3 then
		MsgBoxManager:showTipBox(LocalStrings.NEWVIP_TEXT26)
	end
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellNewVipMedal:createElement()
	if CellNewVipMedal.m_root ~= nil then
		WindowManager:removeWindow(CellNewVipMedal.m_root, CellNewVipMedal, true)
	end
	local element = WZUISystem:getInstance():createElement("CellNewVipMedal")
	assert(element, "CellNewVipMedal create element failed!")
	self:_init()
	return element
end


--==============徽章子项===================
MedalBadgeItem = {}
function MedalBadgeItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nIndex = 1
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function MedalBadgeItem:_unInit()
	self.m_root = nil
	self.m_nIndex = 1
end

--@brief	创建控件
function MedalBadgeItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(190,240))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function MedalBadgeItem:setMedalItemData(data,stage, index)
	self.m_tMedalItemData = data
	self.m_nStage = stage
	self.m_nIndex = index
end
--@brief 	开始加载
function MedalBadgeItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("medalItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()
	AdaptLanguage(self)
end

function MedalBadgeItem:setData()
	if not self.m_tMedalItemData then return end

	local nDataIndex = self.m_nStage > 0 and self.m_nStage + 1 or 1
	local data = self.m_tMedalItemData[nDataIndex]
--	WZLog("MedalBadgeItem:setData", self.m_nStage, Serialize(self.m_tMedalItemData))
	if not data then return end

	local img_icon = GetElement(self.m_root,"img_icon",WZUIImage)
	local str_icon = data.icon
	local bExist = WZFileUtil:isFileExist(str_icon)
	if not bExist then
		str_icon = "shopitems/icon_xzdj_01.png"
	end
	img_icon:setFile(str_icon)
	local txtMedalName = GetElement(self.m_root,"txtMedalName",WZUILabelTTF)
	txtMedalName:setText(data.title)

	if self.m_nStage > 0 then
		local spineIcon = WZUISpine:create()
		spineIcon:setTouchEnable(false)
		spineIcon:setRelativePosition(GlobalMethod:ccp(0.489,0.7))
		self.m_root:addChild(spineIcon)

		GetElement(self.m_root,"maskMedal", WZUI9Image):setVisible(false)
		for i=1,self.m_nStage do
			GetElement(self.m_root,"star"..i,WZUIImage):setVisible(true)
		end
		if self.m_nIndex >= 7 then
		else
			spineIcon:setRelativePosition(GlobalMethod:ccp(0.489,0.666))
		end
		if data.path ~= 0 then 
			local existSpine = CheckEffectFile("ui/otherUI/" .. data.path)
			if existSpine then 
				spineIcon:setFileAtlas("ui/otherUI/" .. data.path .. ".atlas")
				spineIcon:setFileJson("ui/otherUI/" .. data.path .. ".json")

				spineIcon:setAnimationName(data.animation)
				spineIcon:play(data.animation, true)
			else
				local _sIndex = data.path
		        local downloadInfo = GetDownloadInfo(_sIndex, "uiEffect")
		        if downloadInfo then 
		        	DownloadManager:addDownloadTask(14021 + data.id,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
		        end
			end
		end
	else
		GetElement(self.m_root,"maskMedal", WZUI9Image):setVisible(true)
	end
end

function MedalBadgeItem:onBtnClickMedalMsg()
	local nIndex = 1
	for i=1,#self.m_tMedalItemData do
		if self.m_tMedalItemData[i].stage == self.m_nStage then
			nIndex = i
			break
		end
	end
	if self.m_tMedalItemData[nIndex] then
		local item = CellMedalMsh:createElement()
		if item then
			WindowManager:addWindow(item,CellMedalMsh,nil,false)
		end
		CellMedalMsh:setMedalItemType(self.m_tMedalItemData[nIndex].type, self.m_tMedalItemData[nIndex].title, self.m_tMedalItemData[nIndex].subtitle)
	end
end
--@return	新建的表实例对象
function MedalBadgeItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function MedalBadgeItem:_adaptLanguage_vn()
	local txtMedalName = GetElement(self.m_root,"txtMedalName",WZUILabelTTF)
	txtMedalName:setScale(0.7)
end
-------------------------------------语言适配End----------------------------------------