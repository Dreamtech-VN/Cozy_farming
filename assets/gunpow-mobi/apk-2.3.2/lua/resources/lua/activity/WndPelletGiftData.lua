--WndPelletGiftData.lua
--@brief	WndPelletGift的数据模块
--@date		2021/09/13
--@author	hyx
--@note		童年礼物

WndPelletGift = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPelletGift:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGiftData = nil
	self.m_tShowGiftRewardData = {}
	self.m_tLightStatus = {}
	self.m_tGiftItem = {}
	self.m_tPhotoId = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPelletGift:_unInit()
	self.m_root = nil
	self.m_tGiftData = nil
	self.m_tShowGiftRewardData = {}
	self.m_tLightStatus = {}
	self.m_tGiftItem = {}
	self.m_tPhotoId = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPelletGift:createElement(gift_data, light_data, photo_data)
	if WndPelletGift.m_root ~= nil then
		WindowManager:removeWindow(WndPelletGift.m_root, WndPelletGift, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPelletGift")
	assert(element, "WndPelletGift create element failed!")
	self:_init()
	self.m_tGiftData = gift_data
	self.m_tLightStatus = light_data
	self.m_tPhotoId = photo_data
	return element
end


--======= 点亮图册子项 ========
PelletGiftItem = {}
function PelletGiftItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGoodItemCell = {}
	self.m_nLightState = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function PelletGiftItem:_unInit()
	self.m_root = nil
	self.m_tGoodItemCell = {}
	self.m_nLightState = nil
end

--@brief	创建控件
function PelletGiftItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(658,122))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function PelletGiftItem:setRewardData(index,data)
	self.m_nSortIndex = index
	self.m_tRewardData = data
end

--@brief 	开始加载
function PelletGiftItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("GiftItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()	
end
function PelletGiftItem:setData()
	if not self.m_tRewardData then return end

	self.m_tGoodItemCell[self.m_nSortIndex] = {}
	self:setLevelItemMessage(self.m_nSortIndex, self.m_tRewardData.index, self.m_tRewardData)
end
function PelletGiftItem:setLevelItemMessage(sort_index, index, data)
	GetElement(self.m_root,"txtTitleName",WZUILabelTTF):setText(LocalStrings.ACTIVITY_TEXT167[index])
	GetElement(self.m_root,"btnGoto",WZUIButton):setVisible(data.lightStatus == 0)
	GetElement(self.m_root,"btnGet",WZUIButton):setVisible(data.lightStatus == 1)
	GetElement(self.m_root,"imgGet",WZUIImage):setVisible(data.lightStatus == 2)

	self.m_nLightState = index
	local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
	HoraryLevelRewardItem:setCommonRewardData(sort_index, 6, data.ids, data.nums, goods_con, WndPelletGift, self.m_tGoodItemCell)
end
function PelletGiftItem:onBtnGoto()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(WndPelletGift.m_root, WndPelletGift, true)
end
function PelletGiftItem:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_nLightState then return end
	local tab = {}
	tab.photoId = self.m_nLightState
	tab = json.encode(tab)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7028, 5, tab)
end
--@return	新建的表实例对象
function PelletGiftItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
