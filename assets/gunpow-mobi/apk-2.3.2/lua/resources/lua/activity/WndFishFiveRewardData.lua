--WndFishFiveRewardData.lua
--@brief	WndFishFiveReward的数据模块
--@date		2021/08/26
--@author	hyx
--@note		钓鱼5钓奖励

WndFishFiveReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFishFiveReward:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRewardData = nil
	self.m_tFiveBigIds = {}
	self.m_tFiveBigNums = {}
	self.m_tFiveSpecialIds = {}
	self.m_tFiveSpecialNums = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFishFiveReward:_unInit()
	self.m_root = nil
	self.m_tRewardData = nil
	self.m_tFiveBigIds = {}
	self.m_tFiveBigNums = {}
	self.m_tFiveSpecialIds = {}
	self.m_tFiveSpecialNums = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFishFiveReward:createElement()
	if WndFishFiveReward.m_root ~= nil then
		WindowManager:removeWindow(WndFishFiveReward.m_root, WndFishFiveReward, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFishFiveReward")
	assert(element, "WndFishFiveReward create element failed!")
	self:_init()
	return element
end
function WndFishFiveReward:setRewardData(data)
	self.m_tRewardData = data
end
--=========== 5钓领取子项 ===============
CellFiveRewardItem = {}
function CellFiveRewardItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tFiveType = nil
	self.m_tFiveIds = {}
	self.m_tFiveNums = {}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFiveRewardItem:_unInit()
	self.m_root = nil
	self.m_tFiveType = nil
	self.m_tFiveIds = {}
	self.m_tFiveNums = {}
end

--@brief	创建控件
function CellFiveRewardItem:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(480,70))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

function CellFiveRewardItem:setFiveRewardData(_type, ids, nums)
	self.m_tFiveType = _type
	self.m_tFiveIds = ids
	self.m_tFiveNums = nums
end
--@brief 	开始加载
function CellFiveRewardItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("fiveRewardItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()
end

function CellFiveRewardItem:setData()
	local conFishType = GetElement(self.m_root,"conFishType",WZUIContainer)
	local fish_name = {"ui/activityWords/dy_caoyu.png","ui/activityWords/dy_luofeiyu.png","ui/activityWords/dy_longxia.png","ui/activityWords/dy_jiyu.png","ui/activityWords/dy_jinli.png"}
	GetElement(conFishType,"imgFish",WZUIImage):setFile(fish_name[self.m_tFiveType])
	local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
	for i=1, #self.m_tFiveIds do
		local info = GDatatab_item["id_"..self.m_tFiveIds[i]]
		local num = self.m_tFiveNums[i]
		if info then
			local itemInfo = {lastTime=num,lastNum=num,basicInfo=CopyTable(info)}
			local celElement, tLuaObj = CellGoodItem:createElement()
			goods_con:addChild(celElement)
			celElement:setScale(0.7)
			celElement:setUseAbsCoordinate(true)
			tLuaObj:setCellGoodItem(itemInfo, 17)
			tLuaObj:setItemClickFun(WndFishFiveReward,self.onItemClick)
			local _x = 45 + (i-1) * 80
			celElement:setAbsPosition(GlobalMethod:ccp(_x, 35))
		end
	end
end
function CellFiveRewardItem:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndFishFiveReward.m_root,1,tData,false,nil,true)
end
--@return	新建的表实例对象
function CellFiveRewardItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
