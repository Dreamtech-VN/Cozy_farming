--WndFightActivity2Data.lua
--@brief	WndFightActivity2的数据模块
--@date		2021/06/21
--@author	hyx
--@note		战力提升

WndFightActivity2 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFightActivity2:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRoleData = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFightActivity2:_unInit()
	self.m_root = nil
	self.m_tRoleData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFightActivity2:createElement()
	if WndFightActivity2.m_root ~= nil then
		WindowManager:removeWindow(WndFightActivity2.m_root, WndFightActivity2, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFightActivity2")
	assert(element, "WndFightActivity2 create element failed!")
	self:_init()
	return element
end


--=========== 战力飞升榜子项 ===============
CellFightItem2 = {}
function CellFightItem2:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nType = 1   					--1:战力飞升；2：新萌榜；3：耀眼榜
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFightItem2:_unInit()
	self.m_root = nil
	self.m_nType = nil 
end

--@brief	创建控件
function CellFightItem2:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(540,80))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end
function CellFightItem2:setFightItemData(data, nType)
	self.m_nFightData = data
	self.m_nType = nType or 1
end
--@brief 	开始加载
function CellFightItem2:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("ItemFightCon")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()
end

function CellFightItem2:setData()
	if not self.m_nFightData then return end
	local data = self.m_nFightData
	local imgRankIndex = GetElement(self.m_root,"imgRankIndex",WZUIImage)
	imgRankIndex:setVisible(false)
	local txtRankIndex = GetElement(self.m_root,"txtRankIndex",WZUILabelTTF)
	imgRankIndex:setVisible(false)
	local rank_name = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
	if tonumber(data.rank_index) <= 3 then
		imgRankIndex:setVisible(true)
		imgRankIndex:setFile(rank_name[tonumber(data.rank_index)])
	else
		txtRankIndex:setVisible(true)
		txtRankIndex:setText(tostring(data.rank_index))
	end
	local img_bg = GetElement(self.m_root,"img_bg",WZUI9Image)
	if CacheCenter:getPlayerInfo().id == data.playerId then
   		img_bg:setFile("ui/common/frame_lieb_01.png")
   	else
   		img_bg:setFile("ui/common/frame_lieb_03.png")
   	end

	local txtName = GetElement(self.m_root,"txtName",WZUILabelTTF)
	txtName:setText(data.name)
	if data.serverId and data.serverId ~= CacheCenter:getPlayerInfo().serverId then 
		GetElement(self.m_root, "imgKuafu_ItemFightCon", WZUIImage):setVisible(true)
   		txtName:setRelativePosition(GlobalMethod:ccp(0.26,0.5))
	end
	local txtFight = GetElement(self.m_root,"txtFight",WZUILabelTTF)
	txtFight:setText(data.point)
	if self.m_nType == 3 then 
		txtName:setFontSize(18)
		txtFight:setRelativePosition(GlobalMethod:ccp(0.455,0.5))
	end
   	local head_con = GetElement(self.m_root,"head_con",WZUIContainer)
   	if self.m_nType == 2 then 
   		head_con:setVisible(false)
   		txtName:setRelativePosition(GlobalMethod:ccp(0.14,0.5))
   		if data.serverId and data.serverId ~= CacheCenter:getPlayerInfo().serverId then 
   			txtName:setRelativePosition(GlobalMethod:ccp(0.17,0.5))
   		end
   		GetElement(self.m_root, "btnPlayer_ItemFightCon", WZUIButton):setVisible(true)
   	else
   		CellHead:show(head_con, data.headId, data.faceId, data.sex, false, nil, data.vipLevel, data.headColor, nil, nil, nil, nil, data.headEffectId)
   	end

	if data.reward_id then
		for i=1, #data.reward_id do
			local itemInfo = {lastTime=data.reward_num[i],lastNum=data.reward_num[i],basicInfo=CopyTable(GDatatab_item["id_"..data.reward_id[i]])}
			local celElement, tLuaObj = CellGoodItem:createElement()
			self.m_root:addChild(celElement)
			celElement:setScale(0.86)
			celElement:setUseAbsCoordinate(true)

			tLuaObj:setCellGoodItem(itemInfo, 17)
			tLuaObj:setItemClickFun(self,self.onItemClick)
			local _x = 655 - i * 85
			celElement:setAbsPosition(GlobalMethod:ccp(_x, 40))
			celElement:setVisible(true)
		end
	end
end

function CellFightItem2:onBtnHead()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nFightData then
		ProtocolProcessorWndBag:regAll1()
		ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo(self.m_nFightData.playerId) 
	end
end
function CellFightItem2:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WZLog("CellFightItem2:onItemClick", self.m_nType)
    local tempRoot = WndFightActivity2.m_root
    if self.m_nType == 2 then 
    	tempRoot = WndNewCuteList.m_root
    elseif self.m_nType == 3 then 
    	tempRoot = WndDazzleRank.m_root
   	end
   	WndItemInfo:showInfo(tCell.m_root, tempRoot, 1, tData, false, nil, true)
end
--@return	新建的表实例对象
function CellFightItem2:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
