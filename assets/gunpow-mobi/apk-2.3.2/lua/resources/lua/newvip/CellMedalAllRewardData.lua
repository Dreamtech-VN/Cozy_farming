--CellMedalAllRewardData.lua
--@brief	CellMedalAllReward的数据模块
--@date		2021/04/08
--@author	hyx
--@note		徽章所有奖励

CellMedalAllReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellMedalAllReward:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_data = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMedalAllReward:_unInit()
	self.m_root = nil
	self.m_data = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellMedalAllReward:createElement(data)
	if CellMedalAllReward.m_root ~= nil then
		WindowManager:removeWindow(CellMedalAllReward.m_root, CellMedalAllReward, true)
	end
	local element = WZUISystem:getInstance():createElement("CellMedalAllReward")
	assert(element, "CellMedalAllReward create element failed!")
	self:_init()
	self.m_data = data
	return element
end

--排序
function CellMedalAllReward:taskTableSort(data_sort)
	if not data_sort then
		data_sort = {}
	end
	local temp = {
		[-1] = 2, --未领取
		[0] = 1, --可领取
		[1] = 3, --已领取
	}
	local function testFunc(a,b)
		if a.status ~= b.status then
			if temp[a.status] and temp[b.status] then
				return temp[a.status] < temp[b.status]
			else
				return false
			end
		else
			return a.id < b.id
		end
	end
	table.sort(data_sort, testFunc)
end

--===============================
AllRewardItem = {}
function AllRewardItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function AllRewardItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function AllRewardItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(888,108))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function AllRewardItem:setAllRewardData(data)
	self.m_tRewardData = data
end
--@brief 	开始加载
function AllRewardItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("AllRewardItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setRewardItem()

	AdaptLanguage(self)
end

function AllRewardItem:setRewardItem()
	if not self.m_tRewardData then return end

	local data = self.m_tRewardData
	local img_icon = GetElement(self.m_root,"icon",WZUIImage)
	local str_icon = data.icon
	local bExist = WZFileUtil:isFileExist(str_icon)
	if not bExist then
		str_icon = "shopitems/icon_xzdj_01.png"
	end
	img_icon:setFile(str_icon)

	local txtRewardLev = GetElement(self.m_root,"txtRewardLev",WZUILabelTTF)
	txtRewardLev:setText(string.format(LocalStrings.NEWVIP_TEXT24,data.level))

	GetElement(self.m_root,"btnGet",WZUIButton):setVisible(data.status == 0)
	GetElement(self.m_root,"img_get",WZUIImage):setVisible(data.status == 1)
	GetElement(self.m_root,"txtNotFinish_CellMedalAllReward", WZUILabelTTF):setVisible(data.status == -1)

	local good_con = GetElement(self.m_root,"good_con",WZUIContainer)
	local sex = CacheCenter:getPlayerInfo().sex
	local index = 1
	for i = 1, #data.reward do
		local items = GDatatab_item["id_"..data.reward[i][1]]
		if items then
			if items.sex == 2 or items.sex == sex then
				local celElement, tNewObj = CellGoodItem:createElement()
				good_con:addChild(celElement)
			    local itemInfo = {id=i, name=items.name,icon=items.icon,lastNum=data.reward[i][2],quality=items.quality,basicInfo=items}
			    tNewObj:setCellGoodItem(itemInfo,17)
			    tNewObj:setItemClickFun(self,self.onItemClick)
			    celElement:setAbsPosition(GlobalMethod:ccp(60+(90 * (index-1)),45))
			    index = index + 1
			end
		end
	end
end
function AllRewardItem:onItemClick(tCell,tag,tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if tData == nil then
        return
    end
	WndItemInfo:showInfo(tCell.m_root,CellMedalAllReward.m_root,1,tData,false,nil,true)	
end

function AllRewardItem:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tRewardData then
		ProtocolProcessorWndRankList:send_PLAYER2_ReceiveVipMedalLevelReward(self.m_tRewardData.id )
	end
end
--@return	新建的表实例对象
function AllRewardItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@return	新建的表实例对象
function AllRewardItem:_adaptLanguage_vn( )
	GetElement(self.m_root,"txtRewardLev",WZUILabelTTF):setFontSize(20)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
