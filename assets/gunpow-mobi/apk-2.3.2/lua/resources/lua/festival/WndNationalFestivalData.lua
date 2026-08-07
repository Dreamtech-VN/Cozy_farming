--WndNationalFestivalData.lua
--@brief	WndNationalFestival的数据模块
--@date		2020/09/07
--@author	hyx
--@note		国庆签到

WndNationalFestival = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndNationalFestival:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sItemFreeList = nil
	self.m_tFestivalLoginList = {} --用来存储签到项
	self.m_tLoginGetStatus = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndNationalFestival:_unInit()
	self.m_root = nil
	self.m_sItemFreeList = nil
	self.m_tFestivalLoginList = {}
	self.m_tLoginGetStatus = {}
end

function WndNationalFestival:setRechargeSignIn()
	local rechargeSignIn = CacheCenter:getGameParam().rechargeSignIn
	if rechargeSignIn then
		--获取充值类型和商品排序
		rechargeSignIn = json.decode(rechargeSignIn)
		self.m_nRechargeType = rechargeSignIn.rechargeType
		self.m_nRechargeSort = rechargeSignIn.rechargeSort
		self.m_nLotteryNum = rechargeSignIn.lotteryNum or 0
	end
end
function WndNationalFestival:getRechargeData()
	return self.m_nRechargeType, self.m_nRechargeSort
end
function WndNationalFestival:getLotteryNum()
	return self.m_nLotteryNum
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndNationalFestival:createElement()
	if WndNationalFestival.m_root ~= nil then
		WindowManager:removeWindow(WndNationalFestival.m_root, WndNationalFestival, true)
	end
	local element = WZUISystem:getInstance():createElement("WndNationalFestival")
	assert(element, "WndNationalFestival create element failed!")
	self:_init()
	return element
end
--************* 选择好友 ****************
CellNotionalFestivalItem = {}
function CellNotionalFestivalItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNotionalFestivalItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellNotionalFestivalItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(154,284))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function CellNotionalFestivalItem:setNationalFestivalMessage(index, data)
	self.m_nDayIndex = index
	self.m_tFestivalLoginData = data
end
--@brief 	开始加载
function CellNotionalFestivalItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("festival_item")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:nationalFestivalDateItem()

	AdaptLanguage(self)
end

function CellNotionalFestivalItem:nationalFestivalDateItem()
	if not self.m_tFestivalLoginData then return end

	local data = self.m_tFestivalLoginData
	local item_title = GetElement(self.m_root,"item_title",WZUILabelTTF)
	item_title:setText(string.format(LocalStrings.SingInDAYS,self.m_nDayIndex))

	self:setBtnGetStatus(data.status)

	local item_good = GetElement(self.m_root,"item_good",WZUIContainer)
	local key = "id_"..data.id
	local tabItem = GDatatab_item[key]
	local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=data.num,quality=tabItem.quality,basicInfo=CopyTable(tabItem)}
	local celElement,tCell = CellGoodItem:createElement()
	tCell:setCellGoodItem(itemInfo,5)
	tCell:setItemClickFun(WndNationalFestival,self.onItemClick)
	item_good:addChild(celElement)

	local item_name = GetElement(self.m_root,"item_name",WZUILabelTTF)
	item_name:setText(tabItem.name)
	item_name:setColor(QUALITYCOLOR[GDatatab_item[key].quality])

	local item_count = GetElement(self.m_root,"item_count",WZUILabelTTF)
	item_count:setText(data.num)
end
--按钮领取状态
function CellNotionalFestivalItem:setBtnGetStatus(status)
	if not self.m_root then return end

	local img_get = GetElement(self.m_root,"img_get",WZUIImage)
	img_get:setVisible(false)
	local btn_goto = GetElement(self.m_root,"btn_goto",WZUIButton)
	local btn_label = GetElement(btn_goto,"btn_label",WZUILabelTTF)
	btn_label:setText(LocalStrings.ACTIVE_BTN_GET)
	if status == -1 then --不能领取
		btn_goto:setTouchEnable(false)
		btn_label:setEnableStroke(false)
		btn_label:setColor(GlobalMethod:ccc3(255,255,255))
		btn_label:setStrokeColor(GlobalMethod:ccc3(80,61,50))
	elseif status == 0 then
		btn_goto:setTouchEnable(true)
		img_get:setVisible(false)
		btn_goto:setVisible(true)
		btn_label:setEnableStroke(true)
		btn_label:setColor(GlobalMethod:ccc3(255,250,236))
		btn_label:setStrokeColor(GlobalMethod:ccc3(0,108,3))
	elseif status == 1 then --已领取
		img_get:setVisible(true)
		btn_goto:setVisible(false)
	end
end
--领取
function CellNotionalFestivalItem:onClickBtnGet()
	if self.m_nDayIndex then
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(tonumber(g_cityExtenInfo.rechargeSignInActivity), self.m_nDayIndex-1, 1)
	end
end 
--@brief	点击物品弹出对应的tips
function CellNotionalFestivalItem:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndNationalFestival.m_root,1,tData,false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@return	新建的表实例对象
function CellNotionalFestivalItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------

--@brief	越南适配
function CellNotionalFestivalItem:_adaptLanguage_vn()
	GetElement(self.m_root,"item_name",WZUILabelTTF):setScale(0.7)
end
