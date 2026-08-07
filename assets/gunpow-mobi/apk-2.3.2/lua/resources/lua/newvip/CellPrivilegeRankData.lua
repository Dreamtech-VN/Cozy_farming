--CellPrivilegeRankData.lua
--@brief	CellPrivilegeRank的数据模块
--@date		2021/04/07
--@author	hyx
--@note		名人榜

CellPrivilegeRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellPrivilegeRank:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nMyRank = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPrivilegeRank:_unInit()
	self.m_root = nil
	self.m_nMyRank = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellPrivilegeRank:createElement()
	if CellPrivilegeRank.m_root ~= nil then
		WindowManager:removeWindow(CellPrivilegeRank.m_root, CellPrivilegeRank, true)
	end
	local element = WZUISystem:getInstance():createElement("CellPrivilegeRank")
	assert(element, "CellPrivilegeRank create element failed!")
	self:_init()
	return element
end

function CellPrivilegeRank:setRankData( playerId, ranking, name, level, faceId, headId, sex, param1, param3, vipLevel, headColor, headEffectId, qqHallInfo)
	local data = {}
	for i = 0, ranking:size() - 1 do
		local temp = {}
		temp.playerId   = playerId:get(i)
		temp.ranking   = ranking:get(i)
		temp.name   = name:get(i)
		temp.level   = level:get(i)
		temp.faceId   = faceId:get(i)
		temp.headId   = headId:get(i)
		temp.sex   = sex:get(i)
		temp.score   = param1:get(i)
		temp.guild_name   = param3:get(i)
		temp.vipLevel   = vipLevel:get(i)
		temp.headColor   = headColor:get(i)
		temp.headEffectId   = headEffectId:get(i)
		if qqHallInfo and qqHallInfo:get(i) ~= "" then 
			temp.qqHallData = json.decode(qqHallInfo:get(i))
		end

		data[i+1] = temp
	end
	return data
end

function CellPrivilegeRank:setMyRank(rank)
	self.m_nMyRank = rank
end
function CellPrivilegeRank:getMyRank()
	if self.m_nMyRank then
		return self.m_nMyRank
	end
	return 0
end

--==============排行榜子项===================
PrivilegeRankItem = {}
function PrivilegeRankItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function PrivilegeRankItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function PrivilegeRankItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(910,94))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
--[[
_type 1:名人榜 2:名人榜奖励
]]
function PrivilegeRankItem:setRankItemData(_type,data)
	self.m_nType = _type
	self.m_tRankData = data
end
--@brief 	开始加载
function PrivilegeRankItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("conPrivilegeRankItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:cellPrivilegeRankItem()
end

function PrivilegeRankItem:cellPrivilegeRankItem()
	if not self.m_tRankData then return end

	local data = self.m_tRankData
	local imgRankBg = GetElement(self.m_root,"imgRankBg",WZUI9Image)
	local bg_str = {"ui/newvip/frame_mrb_01.png","ui/newvip/frame_mrb_02.png","ui/newvip/frame_mrb_03.png"}
	local rank_name = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
	local imgRank = GetElement(self.m_root,"imgRank",WZUIImage)
	imgRank:setVisible(false)
	local txtRank = GetElement(self.m_root,"txtRank",WZUILabelTTF)

	if self.m_nType == 1 then
		if data.ranking <= 3 then
			imgRank:setVisible(true)
			imgRank:setFile(rank_name[tonumber(data.ranking)])
			imgRankBg:setFile(bg_str[tonumber(data.ranking)])
		else
			txtRank:setText(data.ranking)
			imgRankBg:setFile("ui/common/frame_lieb_03.png")
			imgRankBg:setOpacity(206)
		end
		GetElement(self.m_root,"rankContainer",WZUIContainer):setVisible(true)
		self:setShowRankItemData(data.headId, data.faceId, data.sex, data.score, data.guild_name, data.level, data.name, data.vipLevel, data.headColor, data.headEffectId, data.qqHallData)
	elseif self.m_nType == 2 then
		txtRank:setAnchorPoint(ccp(0,0.5))
		txtRank:setRelativePosition(ccp(0.02,0.5))
		if data.rank[1][1] == data.rank[1][2] and data.rank[1][1] <= 3 then
			imgRank:setVisible(true)
			imgRank:setFile(rank_name[tonumber(data.rank[1][1])])
			imgRankBg:setFile(bg_str[tonumber(data.rank[1][1])])
		else
			txtRank:setText(string.format(LocalStrings.NEWVIP_TEXT21,data.rank[1][1], data.rank[1][2]))
			imgRankBg:setFile("ui/common/frame_lieb_03.png")
			imgRankBg:setOpacity(206)
		end
		GetElement(self.m_root,"rewardContainer",WZUIContainer):setVisible(true)
		self:setRewardRankData(data)
	end
end
--排行榜
function PrivilegeRankItem:setShowRankItemData(headId, faceId, sex, score, guild, lev, name, vipLevel, headColor, headEffectId, qqHallData)
	local head_con = GetElement(self.m_root,"head_con",WZUIContainer)
	CellHead:show(head_con, headId, faceId, sex, false, nil, nil, headColor, nil, nil, nil, nil, headEffectId)

	local txtPlayerName = GetElement(self.m_root,"txtPlayerName",WZUIFreeTextBox)
	local strQQBluePath = ""
    local strQQYearPath = ""
    local bShowQQInfo = true 
    if ProjConfig:getChannelId() ~= 1118 then 
        bShowQQInfo = false 
    end
    --qq大厅蓝钻年费图标
    if qqHallData and bShowQQInfo then 
        if qqHallData.is_blue_vip or qqHallData.is_super_blue_vip then 
            if qqHallData.is_super_blue_vip then 
                strQQBluePath = "ui/qqHall/hh_" .. qqHallData.blue_vip_level .. ".png"
            else 
                strQQBluePath = "ui/qqHall/pz_" .. qqHallData.blue_vip_level .. ".png"
            end
            if qqHallData.is_blue_year_vip then 
                strQQYearPath = "ui/qqHall/nian.png"
            end
        end
    end
    local str = [[<T C="127,70,26" S="22" P="1">Lv</T><T C="229,105,22" S="22" P="1">%s</T><I Z="0.6" P="1">%s</I><I Z="0.6" P="1">%s</I><T C="127,70,26" S="22" P="1">%s</T>]]
    txtPlayerName:setShowText(string.format(str, lev, strQQBluePath, strQQYearPath, name))

	GetElement(self.m_root,"txtMedalScore",WZUILabelTTF):setText(score)
	GetElement(self.m_root,"txtGuild",WZUILabelTTF):setText(guild)
	local img_vip = GetElement(self.m_root,"img_vip",WZUIImage)
	if vipLevel <= 15 then
        img_vip:setFile("ui/newvip/common_icon_hgg.png")
    elseif vipLevel >= 16 and vipLevel <= 19 then
        img_vip:setFile("ui/newvip/common_icon_hgg_1.png")
    elseif vipLevel > 19 and vipLevel <= 22 then
        img_vip:setFile("ui/newvip/common_icon_hgg_2.png")
    elseif vipLevel > 22 then 
        img_vip:setFile("ui/newvip/common_icon_hgg_3.png")
    end
    GetElement(self.m_root,"txtCurLevel",WZUILabelAtlasFont):setText(vipLevel)
end

--奖励
function PrivilegeRankItem:setRewardRankData(data)
	local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
	local pInfo = CacheCenter:getPlayerInfo()
	local reward = {}
	if pInfo.sex == 0 then
		reward = data.reward_boy
	else
		reward = data.reward_girl
	end
	for i=1, #reward do
		local key = "id_"..reward[i][1]
		if GDatatab_item[key] then
		    local name = GDatatab_item[key].name
		    local path = GDatatab_item[key].icon
		    local quality = GDatatab_item[key].quality
		    local num = reward[i][2]
			local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		    local celElement,tLuaObj = CellGoodItem:createElement()
		    tLuaObj:setCellGoodItem(itemInfo, 17)
		    celElement:setScale(0.9)
			goods_con:addChild(celElement)
			tLuaObj:setItemClickFun(CellNewVipPrivilegeRank,self.onRankItemClick)

			celElement:setUseAbsCoordinate(true)
			celElement:setAbsPosition(GlobalMethod:ccp(560-(i-1)*80,45))
		end
	end
end
function PrivilegeRankItem:onRankItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,CellNewVipPrivilegeRank.m_root,1,tData,false,nil,true)
end

function PrivilegeRankItem:onClickHead()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorWndBag:regAll1()
	if not self.m_tRankData then return end
	ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo(self.m_tRankData.playerId) 
end

--@return	新建的表实例对象
function PrivilegeRankItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
