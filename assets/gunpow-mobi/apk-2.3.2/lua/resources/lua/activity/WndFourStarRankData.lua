--WndFourStarRankData.lua
--@brief	WndFourStarRank的数据模块
--@date		2021/02/24
--@author	hyx
--@note		排行榜

WndFourStarRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFourStarRank:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tBtnTitle = {}
	self.m_nCurIndex = 2
	self.m_tSummonRankData = {}
	self.m_tLibraryRankData = {}
	self.m_sSummonCon = nil
	self.m_sTxtShowSummonPlayer = nil
	self.m_sLibraryCon = nil
	self.m_sTxtShowLibraryPlayer = nil
	self.m_sFreeMySummonTxt = nil
	self.m_sFreeMyRankTxt1 = nil
	self.m_sFreeMyLibraryTxt = nil
	self.m_sFreeMyRankTxt2 = nil
	self.m_nActivityId = nil
	self.m_nSurfaceType = 1
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFourStarRank:_unInit()
	self.m_root = nil
	self.m_tBtnTitle = {}
	self.m_nCurIndex = 2
	self.m_tSummonRankData = {}
	self.m_tLibraryRankData = {}
	self.m_sSummonCon = nil
	self.m_sTxtShowSummonPlayer = nil
	self.m_sLibraryCon = nil
	self.m_sTxtShowLibraryPlayer = nil
	self.m_sFreeMySummonTxt = nil
	self.m_sFreeMyRankTxt1 = nil
	self.m_sFreeMyLibraryTxt = nil
	self.m_sFreeMyRankTxt2 = nil
	self.m_nActivityId = nil
	self.m_nSurfaceType = 1
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFourStarRank:createElement(activityId, _type)
	if WndFourStarRank.m_root ~= nil then
		WindowManager:removeWindow(WndFourStarRank.m_root, WndFourStarRank, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFourStarRank")
	assert(element, "WndFourStarRank create element failed!")
	self:_init()
	self.m_nActivityId = tonumber(activityId) or tonumber(g_cityExtenInfo.activity7008)
	self.m_nSurfaceType = _type --默认是四星象 2:弹珠
	return element
end


--================== 排行榜子项 ========================
CellLibraryRankItem = {}
function CellLibraryRankItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLibraryRankItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellLibraryRankItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(822,82))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellLibraryRankItem:setGiftBuyMessage(index, data, _type)
	self.m_nIndex = index
	self.m_tRankItemData = data
	self.m_nActivityType = _type or 1
end

--@brief 	开始加载
function CellLibraryRankItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("rank_item")
	celElement:setVisible(true)
	element:addChild(celElement)
	self:setRankDataItem()
end

function CellLibraryRankItem:setRankDataItem()
	if not self.m_tRankItemData then return end
	local data = self.m_tRankItemData

	local img_rank = GetElement(self.m_root,"img_rank",WZUIImage)
	img_rank:setVisible(false)
	local txt_rank = GetElement(self.m_root,"txtRank",WZUILabelTTF)
	local rank_name = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
	txt_rank:setVisible(false)
	if data.rank_index <= 3 then
		img_rank:setVisible(true)
		img_rank:setFile(rank_name[data.rank_index])
	else
		txt_rank:setVisible(true)
		txt_rank:setText(tostring(data.rank_index))
	end
	local img_select = GetElement(self.m_root,"img_select",WZUI9Image)
	if self.m_nActivityType == 2 then
		img_select:setFile("ui/common/frame_lieb.png")
	else
		if CacheCenter:getPlayerInfo().id == data.playerId then
			img_select:setFile("ui/common/frame_lieb_01.png")
		end
	end

	local head_con = GetElement(self.m_root,"head_con",WZUIContainer)
	CellHead:show(head_con, data.headId, data.faceId, data.sex, false, nil, nil, data.headColor)

	GetElement(self.m_root,"name",WZUILabelTTF):setText(data.name)
	GetElement(self.m_root,"txtLv",WZUILabelTTF):setText(data.level)
	GetElement(self.m_root,"txtPoint",WZUILabelTTF):setText(data.point)

	local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
	for i=1, #data.reward_id do
		local key = "id_"..data.reward_id[i]
		if GDatatab_item[key] then
		    local name = GDatatab_item[key].name
		    local path = GDatatab_item[key].icon
		    local quality = GDatatab_item[key].quality
		    local num = data.reward_num[i]
			local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		    local celElement,tLuaObj = CellGoodItem:createElement()
		    tLuaObj:setCellGoodItem(itemInfo, 17)
		    celElement:setScale(0.8)
			goods_con:addChild(celElement)
			tLuaObj:setItemClickFun(WndFourStarRank,self.onRankItemClick)

			celElement:setUseAbsCoordinate(true)
			celElement:setAbsPosition(GlobalMethod:ccp(310-(i-1)*70,40))
		end
	end
end
function CellLibraryRankItem:onRankItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndFourStarRank.m_root,1,tData,false,nil,true)
end
function CellLibraryRankItem:onClickRankHead()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_tRankItemData then return end
	WndCheckOther:show(self.m_tRankItemData.playerId)
end
--@return	新建的表实例对象
function CellLibraryRankItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
