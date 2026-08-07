--WndBluePrivilegeData.lua
--@brief	WndBluePrivilege的数据模块
--@date		2022/03/17
--@author	XTX
--@note		蓝钻特权

WndBluePrivilege = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBluePrivilege:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nLoadingId = nil 
	self.m_tListItem = nil 
	self.m_localActivityItem = {
            {title = LocalStrings.LZTQ_TEXT1[1], activityId = 999998, types = 999999, button_id = 21}
	   }
    self.m_nClickNowId = -1             --当前选择的item
    self.m_nCurrentSelectTypeId = 0         --当前选中的类型ID
    self.m_tCommonPanelElement = nil
    self.m_tCommonPanelLuaObj = nil  
    self.m_cellItemObj = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBluePrivilege:_unInit()
	self.m_root = nil
	self.m_nLoadingId = nil 
	self.m_tListItem = nil 
	self.m_localActivityItem = nil 
    self.m_nClickNowId = nil             --当前选择的item
    self.m_nCurrentSelectTypeId = nil         --当前选中的类型ID
    self.m_tCommonPanelElement = nil
    self.m_tCommonPanelLuaObj = nil  
    self.m_cellItemObj = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBluePrivilege:createElement()
	if WndBluePrivilege.m_root ~= nil then
		WindowManager:removeWindow(WndBluePrivilege.m_root, WndBluePrivilege, true)
	end
	local element = WZUISystem:getInstance():createElement("WndBluePrivilege")
	assert(element, "WndBluePrivilege create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
function WndBluePrivilege:showInterface()
    local wndBlue = WndBluePrivilege:createElement()
    if wndBlue then 
        WindowManager:addWindow(wndBlue, WndBluePrivilege, false)
    end
end

--@brief    获得列表成功
function WndBluePrivilege:GetActivityListInfoOK(types, type2, activityId, title, startTime, endTime)
    --body
    if self.m_root == nil then return end
    local index = 1 
    local serverTime = SystemTime:getServerTime()
    types = VectorToTable(types)
    type2 = VectorToTable(type2)
    activityId = VectorToTable(activityId)
    title = VectorToTable(title)
    startTime = VectorToTable(startTime)
    endTime = VectorToTable(endTime)
    self.m_tListItem = {}

    for i=1,#activityId do
        if type2[i] == 21 then    --等于0 的才是活动
            if serverTime < endTime[i] then 
                if types[i]>0 then 
                    self.m_tListItem[index] = {}
                    self.m_tListItem[index].activityId = activityId[i]
                    self.m_tListItem[index].title = g_tGameActivityTitle[types[i]]
                    WZLog("WndBluePrivilege:GetActivityListInfoOK2", self.m_tListItem[index].title, startTime[i], endTime[i], types[i],activityId[i])
                    self.m_tListItem[index].startTime = startTime[i]
                    self.m_tListItem[index].endTime = endTime[i]
                    self.m_tListItem[index].types = types[i]

                    index = index + 1
                end 
            end 
        end
    end

    for idx, value in pairs(self.m_localActivityItem) do
        table.insert(self.m_tListItem, value)
    end

    self:_closeLoading()
    self:_updateListItem()
end

--@brief  获得活动内容成功
function WndBluePrivilege:GetActivityInfoOK(activityId, maxCount, count, status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	self:_closeLoading()
    WZLog("********* WndBluePrivilege:GetActivityInfoOK ** 66666 ***", activityId, self.m_nCurrentSelectTypeId, content)
	self:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, finishCondition)
end

--@brief    获取其他活动数据
function WndBluePrivilege:_onGetOtherData(activityId, doType, result, jsonData)
    if self.m_root == nil then return end 

    if doType == 1 then --开启结果
        local tResult = json.decode(jsonData)
        WZLog("WndBluePrivilege:_onGetOtherData", Serialize(tResult))
        local nSex = CacheCenter:getPlayerInfo().sex

        local ids, nums = {}, {}
        for i = 1, #tResult.rewards do
            table.insert(ids, tResult.rewards[i][nSex + 1])
            table.insert(nums, tResult.rewards[i][3])
        end

        if result == 1 then 
            WndRewardShow:showById(ids, nums)
            WndRewardShow:closeCallBack(WndBluePrivilege, WndBluePrivilege.refreshActivityContext,  _G, pushEquipInList)
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   创建加载框
function WndBluePrivilege:_createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndBluePrivilege:_closeLoading()
	local nId = self.m_nLoadingId
	MsgBoxManager:stopLoadingBoxByMsgId( nId )
end

--@brief    获取第一个红点的索引
function WndBluePrivilege:_getFirstRedDotItem()
    -- body
    local nFirstIndex = nil 

    for i = 1, #self.m_tListItem do
        if CacheCenter.m_tActivityBluePriRedDotList then
            for idx = 1, #CacheCenter.m_tActivityBluePriRedDotList do
                if self.m_tListItem[i].types == CacheCenter.m_tActivityBluePriRedDotList[idx] then
                    nFirstIndex = i
                    break 
                end
            end
            if nFirstIndex then 
                break
            end
        end
    end

    return nFirstIndex
end
-------------------------------------私有方法模块End----------------------------------------

CellQQActivityItem = {
    -- 请在这里定义和初始化全局成员变量
}

--@brief    定义并初始化表的实例成员变量
--@note     表的实例变量必须在这里定义和初始化
function CellQQActivityItem:_init()
    self.m_root = nil           --Cell的根节点
    self.n_CellItemId = 0       --选项Id
    self.n_CellType = -1
    self.m_bIsLoad = false
    self.m_sName = nil          --活动名称
    self.m_bIsNeedAddRedDot = nil --是否需要添加红点
    self.m_bIsHighLight = false     --是否高亮
end

--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function CellQQActivityItem:_unInit()
    self.m_root = nil
    self.n_CellItemId = nil     --选项Id
    self.n_CellType = nil
    self.m_bIsLoad = nil
    self.m_sName = nil          --活动名称
    self.m_bIsNeedAddRedDot = nil --是否需要添加红点
    self.m_bIsHighLight = nil   --是否高亮
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief    创建控件
--@return   #1，控件element的引用
--@return   #2, 表的引用，也可以用element:getLuaObjectIndex()
--@note     请仅用此方法创建场景
function CellQQActivityItem:createElement()
    local tNewObj = self:_new()
    assert(tNewObj, "CellQQActivityItem table create failed!")
    tNewObj:_init()
    
    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellQQActivityItem")
    element:setAbsContentSize(GlobalMethod:CCSize(166,59))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief    以本表为模版创建一个新的表实例对象
--@return   新建的表实例对象
function CellQQActivityItem:_new( )
    local tNewObj = {}
    setmetatable(tNewObj, self)
    self.__index = self
    return tNewObj
end

--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function CellQQActivityItem:onEnter(element)
    self.m_root = element
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function CellQQActivityItem:onExit(element)
    self:_unInit()
end

--@brief    选项高亮
function CellQQActivityItem:isItemHighLighted(bState)
    self.m_bIsHighLight = bState
    if self.m_bIsLoad == false then return end

    local img_select = GetElement(self.m_root, "img9Sel_CellQQActivityItem", WZUI9Image)
    if bState then 
        img_select:setVisible(true)
    else
        img_select:setVisible(false)
    end 
end

--@brief    点击回调事件
function CellQQActivityItem:onClickCellItem(  )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    local nTag = self.m_root:getTag()
    WZLog("CellQQActivityItem:onClickCellItem", nTag)
    WndBluePrivilege:updataParentByCellItem(nTag + 1)
end

--@brief    设置选项卡名字
function CellQQActivityItem:setItemName(txtName)
    self.m_sName = txtName 
    if self.m_bIsLoad == false then return end
    local txt_subItemName = GetElement(self.m_root, "txt_subItemName_CellQQActivityItem", WZUILabelTTF)
    if txt_subItemName ~= nil then 
        txt_subItemName:setText(txtName)
    end 
end

--@brief    设置选项Id
function CellQQActivityItem:setCellId(tItemData)
    self.n_CellItemId = tItemData.activityId
    self.m_tItemData = tItemData
end

--@brief    获得选项Id
function CellQQActivityItem:getCellItem(  )
    return  self.n_CellItemId
end

--@brief    设置选项类型
function CellQQActivityItem:setCellType( nType )
    self.n_CellType = nType
end

--@brief    获得选项类型
function CellQQActivityItem:getCellType(  )
    return self.n_CellType
end

--@breif 添加红点
function CellQQActivityItem:AddRedDot(bRedDot)
    WZLog("CellQQActivityItem:AddRedDot=====添加小红点=====")
    self.m_bIsNeedAddRedDot = bRedDot
    if self.m_bIsLoad == false then return end 

    if self.m_bIsNeedAddRedDot == true then 
        if not  self.m_root:getChildByTag(99) then 
            local spr_redPoint =  CCSprite:create("ui/common/common_icon_xiaodianzhui.png")
            spr_redPoint:setAnchorPoint(GlobalMethod:ccp(1,1))
            spr_redPoint:setPosition(160, 54)
            spr_redPoint:setScale(0.8)
            self.m_root:addChild(spr_redPoint,5,99)
        end 
    end
end

--@brief 移除红点
function CellQQActivityItem:removeRedDot()
    if self.m_root == nil then 
        return
    end
    if self.m_root:getChildByTag(99) then 
        self.m_root:removeChildByTag(99, true)
        self.m_bIsNeedAddRedDot = false
    end 
end

--@brief    加载cell数据信息
function CellQQActivityItem:onLoadData(element)
    -- body
    WZLog("CellQQActivityItem:onLoadData")
    local cellElement = WZUISystem:getInstance():createElement("CellQQActivityItem_WndBluePrivilege")
    cellElement:setVisible(true)
    self.m_root:addChild(cellElement)

    self.m_bIsLoad = true
    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新显示
function CellQQActivityItem:_update()
    -- body
    --活动名称
    self:setItemName(self.m_sName)
    --红点
    self:AddRedDot(self.m_bIsNeedAddRedDot)
    --高亮、
    self:isItemHighLighted(self.m_bIsHighLight)
end