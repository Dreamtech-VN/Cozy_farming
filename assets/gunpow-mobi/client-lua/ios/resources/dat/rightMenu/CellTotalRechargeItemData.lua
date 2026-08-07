--CellTotalRechargeItemData.lua
--@brief	CellTotalRechargeItem的数据模块
--@date		2014/12/02
--@author	wuweidong
--@note		活动_累计充值子项

CellTotalRechargeItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellTotalRechargeItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.tag = 0
	self.rewardItems = nil
    self.rewardCountOrDay = nil
    self.rewardId = nil
    self.m_tData = nil
    self.rewardItemsParamCount = nil
    self.theirConditions = nil
    self.Parameters1 = nil
    self.Parameters2 = nil
    self.Parameters3 = nil
    self.m_nloadingId = 0
    self.status = nil
    self.index = 0
    self.typeIndex = 0
    self.m_FuncCallback = nil
    self.m_tCallBackLuaObjMap = {}
    self.m_nRechargeDays = 0
    self.m_nCurTarget = nil 
end

--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function CellTotalRechargeItem:_unInit()
    self.m_root = nil
    self.tag = nil
    self.rewardItems = nil
    self.rewardCountOrDay = nil
    self.rewardId = nil
    self.m_tData = nil
    self.rewardItemsParamCount = nil
    self.theirConditions = nil
    self.Parameters1 = nil
    self.Parameters2 = nil
    self.Parameters3 = nil
    self.status = nil
    self.m_nloadingId = nil
    self.index=nil
    self.typeIndex = nil
    self.m_FuncCallback = nil
    self.m_tCallBackLuaObjMap = nil 
    self.m_nRechargeDays = nil
    self.m_nCurTarget = nil 
end

--@breif 设置数据
function CellTotalRechargeItem:setMessage(i,rewardId,tData,Parameters1,status,typeIndex)
	self.tag = i
	self.rewardId = rewardId
	self.m_tData = tData
	self.Parameters1 = Parameters1
    self.status = status
    self.typeIndex = typeIndex
end

--@获得奖励
function CellTotalRechargeItem:ACTIVITY_ReceiveActivityRewardOk(itemsId,count)
    if CellTotalRechargeItem.m_current_click.m_root == nil then
        return
    end
    WZLog("ACTIVITY_ReceiveActivityRewardOk", CellTotalRechargeItem.m_current_click.m_nloadingId)
    MsgBoxManager:removeMsgById(CellTotalRechargeItem.m_current_click.m_nloadingId)
    if itemsId[1]==-1 and count[1]==-1 then
        MsgBoxManager:showTipBox(LocalStrings.REWARD_HAVED_GET)
        table.insert(CellTotalRechargetPanel.m_current.m_tNextId,self.rewardId)
        CellTotalRechargetPanel:_setRewardList()
    else 
		for i=1,#itemsId do
			local tData = GDatatab_item["id_"..itemsId[i]]
			if tData ~= nil and tData.main_type == 20 then
				local show = true
				if COPYSKINDATA ~= nil then  
					local shapeId = tData.property[1][1]
					for i=1,#COPYSKINDATA do
						if COPYSKINDATA[i].shapeId == shapeId then
							if COPYSKINDATA[i].remainTime == -1 then
								show = false
							end
						end
					end
				end
				WZLog("NOTRECYCLEIDS_0", show)
				
				if show == true and (not utilsValueInTable(tData.id, NOTRECYCLESKINIDS)) then
					table.insert(NOTRECYCLESKINIDS, tData.id)
				end
			end
		end

        WndRewardShow:showById(itemsId,count)
        WndRewardShow:closeCallBack(CellTotalRechargeItem.m_current_click,CellTotalRechargeItem.m_current_click._GetRewardOk, _G, pushEquipInList)
    end 
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellTotalRechargeItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellTotalRechargeItem table create failed!")
	tNewObj:_init()
	
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellTotalRechargeItem")
    element:setAbsContentSize(GlobalMethod:CCSize(486,138))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end


function CellTotalRechargeItem:setFunc( func,tNewObj )
    self.m_FuncCallback = func
    self.m_tCallBackLuaObjMap[func] = tNewObj 
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellTotalRechargeItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	--CellTotalRechargeItem.m_current = tNewObj
	return tNewObj
end

--@brief    获取奖励条件提示字
function CellTotalRechargeItem:_getTipWordByUIId(ui_id)
    -- body
    if LocalStrings.GAMEACTIVITY_TIPTEXT2 == nil then return "" end

    if ui_id == 227 then        --商城五连抽
        return LocalStrings.GAMEACTIVITY_TIPTEXT2[4]
    elseif ui_id == 151 then    --幸运召唤
        return LocalStrings.GAMEACTIVITY_TIPTEXT2[1]
    elseif ui_id == 197 then    --符文抽取
        return LocalStrings.GAMEACTIVITY_TIPTEXT2[3]
    elseif ui_id == 64 then     --宠物砸蛋
        return LocalStrings.GAMEACTIVITY_TIPTEXT2[2]
    end
end
-------------------------------------私有方法模块End----------------------------------------
