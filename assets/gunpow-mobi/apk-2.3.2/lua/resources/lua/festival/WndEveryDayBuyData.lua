--WndEveryDayBuyData.lua
--@brief	WndEveryDayBuy的数据模块
--@date		2020/11/30
--@author	hyx
--@note		每日必购

WndEveryDayBuy = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndEveryDayBuy:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sGiftItemFreeListContainer = nil
	self.m_tChooseGiftType = {} --选择礼包的物品
	self.m_sGetContainer = nil
	self.m_sTxtTotleBuy = nil
	self.m_tGetRewardTable = {} --领取的奖励
	self.m_nCurGetIndex = 1
	self.m_tSaveItemCell = {} --保存领取奖励的ItemCell
	self.m_nGiftChooseNum = 1
	self.m_nDayBuyNumLimit = 1
	self.m_nRewardChooseNum = 1
	self.m_nGetChooseNum = 1
	self.m_tGetChooseType = {} --领取礼包的个数
	self.m_tTotleGetCount = {} --累计领取的达到值
	self.m_nTouchBuyTicker = nil --点击购买的定时器
	self.m_tRewardStatus = {}
	self.m_nTotleRewardCount = 0
	self.m_sRemainTimeTicker = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndEveryDayBuy:_unInit()
	self.m_root = nil
	self.m_sGiftItemFreeListContainer = nil
	self.m_tChooseGiftType = {}
	self.m_sGetContainer = nil
	self.m_sTxtTotleBuy = nil
	self.m_tGetRewardTable = {}
	self.m_nCurGetIndex = 1
	self.m_tSaveItemCell = {}
	self.m_nGiftChooseNum = 1
	self.m_nDayBuyNumLimit = 1
	self.m_nRewardChooseNum = 1
	self.m_nGetChooseNum = 1
	self.m_tGetChooseType = {}
	self.m_tTotleGetCount = {}
	self.m_nTouchBuyTicker = nil
	self.m_tRewardStatus = {}
	self.m_nTotleRewardCount = 0
	self.m_sRemainTimeTicker = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndEveryDayBuy:createElement()
	if WndEveryDayBuy.m_root ~= nil then
		WindowManager:removeWindow(WndEveryDayBuy.m_root, WndEveryDayBuy, true)
	end
	local element = WZUISystem:getInstance():createElement("WndEveryDayBuy")
	assert(element, "WndEveryDayBuy create element failed!")
	self:_init()
	return element
end
--礼包可选数量和领取可选数量
function WndEveryDayBuy:setInitData()
	local systemData = CacheCenter:getGameParam().dailyBuyActivityConfig
	if systemData then
		systemData = json.decode(systemData)
		self.m_nGiftChooseNum = systemData.giftChooseNum
		self.m_nDayBuyNumLimit = systemData.dayBuyNumLimit
		self.m_nRewardChooseNum = systemData.rewardChooseNum
	end
end
--限购次数
function WndEveryDayBuy:getLimitBuyCount()
	return self.m_nDayBuyNumLimit
end
--奖励选择
function WndEveryDayBuy:getChooseBuyNum()
	return self.m_nGiftChooseNum
end
--累计购买选择
function WndEveryDayBuy:getRewardChooseNum()
	return self.m_nRewardChooseNum
end
--购买礼包和累计领取的数据
function WndEveryDayBuy:setBuyGiftData(ids, nums, sizes, status, _type, _sort)
	if next(ids) == nil then return {} end
	local data = {}
	local index = 1
	local table_insert = table.insert
	for i=1,#sizes do
		local tab = {}
		local reward = {}
		local num = {}
		if _type then
			local money, id = self:getBuyMoney(_type[i], _sort[i])
			tab.money = money
			tab.change_id = id
			tab.count = status[i]
		end
		for m=1,sizes[i] do
			table_insert(reward, ids[index])
			table_insert(num, nums[index])
			index = index + 1
		end
		tab.reward = reward
		tab.num = num
		
		data[i] = tab
	end
	return data
end
-- 获取购买金额
function WndEveryDayBuy:getBuyMoney(_type, _sort)
	local money = ""
	local id = nil
	for i,v in pairs(GDatatab_recharge) do
		if v.type == _type and v.sort == _sort then
			id = v.id
			break
		end
	end
	
	if id then
		local info = GDatatab_recharge["id_"..id]
		if info then
			money = info.unit
		end
	end
	return money, id
end

--================== 购买礼包子项 ========================
CellEveryDayBuyItem = {}
function CellEveryDayBuyItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nIndex = nil
	self.m_nWidthSize = 0
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellEveryDayBuyItem:_unInit()
	self.m_root = nil
	self.m_nIndex = nil
	self.m_nWidthSize = 0 
end

--@brief	创建控件
function CellEveryDayBuyItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(270,330))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellEveryDayBuyItem:setGiftBuyMessage(index, data)
	self.m_nIndex = index
	self.m_sDayBuyData = data
end

--@brief 	开始加载
function CellEveryDayBuyItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellEveryDayBuyItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setEveryDayBuyDataItem()
end

function CellEveryDayBuyItem:setEveryDayBuyDataItem()
	if not self.m_sDayBuyData then return end

	local img_get = GetElement(self.m_root,"img_get",WZUIImage)
	local btnBuy = GetElement(self.m_root,"btnBuy",WZUIButton)
	local limit = WndEveryDayBuy:getLimitBuyCount()
	btnBuy:setVisible(self.m_sDayBuyData.count < limit)
	img_get:setVisible(self.m_sDayBuyData.count >= limit)


	local txtBtnBuyPrice = GetElement(self.m_root,"txtBtnBuyPrice",WZUILabelTTF)
	if self.m_sDayBuyData.money then
		txtBtnBuyPrice:setText(self.m_sDayBuyData.money..LocalStrings.BUY)
	end
	local good_container = GetElement(self.m_root,"good_container",WZUIContainer)
	for i=1, #self.m_sDayBuyData.reward do
		--物品底框
		local imgItemBg = WZUIImage:create()
		imgItemBg:setUseOriginSize(true)
		imgItemBg:setFile("ui/newActivity/common_fkfb_02.png")
		imgItemBg:setScale(0.8)
		local _x = 54 + ((i-1)%3) * 75
		local _y = 105 - (math.floor((i-1)/3) * 75)
		imgItemBg:setUseAbsCoordinate(true)
		imgItemBg:setAbsPosition(GlobalMethod:ccp(_x, _y))
		good_container:addChild(imgItemBg)

		local key = "id_"..self.m_sDayBuyData.reward[i]
		local tabItem = GDatatab_item[key]
		local num = self.m_sDayBuyData.num[i]
		local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		local celElement,tLuaObj = CellGoodItem:createElement()
		tLuaObj:setCellGoodItem(itemInfo, 17)
        tLuaObj:_setBgImgVisible(false)
        tLuaObj:clearItemQualityPic(false)
		good_container:addChild(celElement,1,i)
		tLuaObj:setGoodItemCallFunc(function(tCell, tag, itenData)
			self:onEveryDayBuyItemClick(tCell, tag, itenData)
		end)
		celElement:setScale(0.8)
		celElement:setUseAbsCoordinate(true)
		local _x = 50 + ((i-1)%3) * 75
		local _y = 110 - (math.floor((i-1)/3) * 75)
		celElement:setAbsPosition(GlobalMethod:ccp(_x,_y))
	end
end

function CellEveryDayBuyItem:setChooseTypeFunc(func, func1)
	self.m_sCHooseTypeCallFunc = func
	self.m_sBuyFunc = func1 --购买的回调
end
-- itenData:点击item的数据
function CellEveryDayBuyItem:onEveryDayBuyItemClick(tCell, tag, itenData)
	if not tCell then return end

	if self.m_sCHooseTypeCallFunc then
		self.m_sCHooseTypeCallFunc(tCell, self.m_nIndex, tag, itenData)
	end
end

function CellEveryDayBuyItem:onBtnClickBuy()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local count = WndEveryDayBuy:getChooseBuyNum()
	if WndEveryDayBuy.m_tChooseGiftType[self.m_nIndex] then
		local choose_num = WndEveryDayBuy:getn_table(WndEveryDayBuy.m_tChooseGiftType[self.m_nIndex])
		if choose_num < count then
			MsgBoxManager:showTipBox(string.format(LocalStrings.EVERYDAYBUY_TEXT2,count))
			return
		end
		if choose_num > count then
			MsgBoxManager:showTipBox(LocalStrings.EVERYDAYBUY_TEXT9)
			return
		end
	end

	if self.m_sBuyFunc then
		self.m_sBuyFunc(self.m_nIndex, self.m_sDayBuyData.change_id)
	end
end

--@return	新建的表实例对象
function CellEveryDayBuyItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
