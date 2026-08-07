--CellGradePanelItemData.lua
--@brief    CellGradePanelItem的数据模块
--@date     2014/12/03
--@author   wuweidong
--@note     限时登录子选项

CellGradePanelItem = {
    -- 请在这里定义和初始化全局成员变量
}

--@brief    定义并初始化表的实例成员变量
--@note     表的实例变量必须在这里定义和初始化
function CellGradePanelItem:_init()
    self.m_root = nil           --Cell的根节点
    self.tag = 0
    self.rewardItems = nil
    self.rewardCountOrDay = nil
    self.rewardId = nil
    self.m_tData = nil
    self.rewardItemsParamCount = nil
    self.m_bIsLoad = false
   
    self.m_nloadingId = 0
    self.nType = 0
    self.nTime = 0
    self.b_canSendProtocol = true
    self.b_needCountDown = false
    self.m_nActivityId = 0
    self.m_FuncCallback = nil
    self.m_tCallBackLuaObjMap = {}
    self.m_cellItemObj = nil 
    self.typeId = 0 --活动类型type-OV琥珀大玩家新加
end

--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function CellGradePanelItem:_unInit()
    self.m_root = nil
    self.tag = 0
    self.rewardItems = nil
    self.rewardCountOrDay = nil
    self.rewardId = nil
    self.rewardItemsParamCount = nil
    self.m_bIsLoad = nil
    
    self.m_nloadingId = 0
    self.nType = 0
    self.nTime = 0
    self.b_canSendProtocol = false
    self.b_needCountDown = false
    self.m_nActivityId = 0
    self.m_FuncCallback = nil
    self.m_tCallBackLuaObjMap = nil 
    self.m_cellItemObj = nil 
    self.typeId = 0 --活动类型type-OV琥珀大玩家新加
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief    创建控件
--@return   #1，控件element的引用
--@return   #2, 表的引用，也可以用element:getLuaObjectIndex()
--@note     请仅用此方法创建场景
function CellGradePanelItem:createElement()
    local tNewObj = self:_new()
    assert(tNewObj, "CellGradePanelItem table create failed!")
    tNewObj:_init()

    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellGradePanelItem")
    element:setAbsContentSize(GlobalMethod:CCSize(640,122))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end

--@brief    设置初始数据
--@parmas   tag    标签
--@parmas   reward 领取ID
--@parmas   tData  物品表
--@parmas   Parameters1   名称
--@parmas   Parameters3   是否可领取
function CellGradePanelItem:setMessage(tag, rewardId, tData, Parameters1, Parameters3, activityId, cellObj)
    self.tag = tag
    self.rewardId = rewardId
    self.m_tData = tData
    self.Parameters1 = Parameters1
    self.Parameters3 = Parameters3
    self.m_nActivityId = activityId
    self.m_cellItemObj = cellObj
end


--@brief    初始化信息 - OV琥珀大玩家
function CellGradePanelItem:setMessage_amberPlayer(type, tag, rewardId, tData, Parameters1, Parameters3, activityId, cellObj)
    self.typeId = type
    self.tag = tag
    self.rewardId = rewardId
    self.m_tData = tData
    self.Parameters1 = Parameters1
    self.Parameters3 = Parameters3
    self.m_nActivityId = activityId
    self.m_cellItemObj = cellObj
end
--@获得奖励
function CellGradePanelItem:ACTIVITY_ReceiveActivityRewardOk(itemsId,count)
    if CellGradePanelItem.m_current_click.m_root == nil then
        return
    end
    MsgBoxManager:removeMsgById(CellGradePanelItem.m_current_click.m_nloadingId)
    if itemsId[1]==-1 and count[1]==-1 then
        MsgBoxManager:showTipBox(LocalStrings.REWARD_HAVED_GET)
    else 
        WZLog("++++++"..CellGradePanelItem.m_current_click.m_nloadingId)
        WndRewardShow:showById(itemsId,count)
        WndRewardShow:closeCallBack(CellGradePanelItem.m_current_click,CellGradePanelItem.m_current_click._GetRewardOk, _G, pushEquipInList)
    end
end

--@设置显示的类型
--0累计登录  2新手累计登录
function CellGradePanelItem:setUIType( nIndex )
    self.nType = nIndex
end

function CellGradePanelItem:setFunc( func,tNewObj )
    self.m_FuncCallback = func
    self.m_tCallBackLuaObjMap[func] = tNewObj 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief    以本表为模版创建一个新的表实例对象
--@return   新建的表实例对象
function CellGradePanelItem:_new( )
    local tNewObj = {}
    setmetatable(tNewObj, self)
    self.__index = self
    CellGradePanelItem.m_current = tNewObj
    return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
