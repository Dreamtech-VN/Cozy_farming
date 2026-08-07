--WndTowerPreview.lua
--@brief	WndTowerPreview的UI模块
--@date		2015/04/28
--@author	xiaoyu_wu
--@note		爬塔副本奖励预览窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTowerPreview:onEnter(element)
	self.m_root = element
     AdaptLanguage(self)
end

----@brief onEnter函数执行完成回调
function WndTowerPreview:onEnterTransitionDidFinish(element)
    --弹窗动画
    --WindowManagerAni:createAppearAction(self.m_root, false, "actionCallback", self)
    self:actionCallback()
end

----@brief    弹窗动画完成后的回调
function WndTowerPreview:actionCallback(element, data)
	--初始化界面
    local txtAwardDesc = GetElement(self.m_root,"txtAwardDesc_WndTowerPreview",WZUIFreeTextBox)
    txtAwardDesc:setShowText(string.format(LocalStrings.TOWER_SEND_DESC,"00:00"))
	self:_initUI()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTowerPreview:onExit(element)
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndTowerPreview:onClose(element)
    WZLog("WndTowerPreview:onClose")
   SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)
end

--@brief  查看爬塔排行榜
function WndTowerPreview:onTowerRankClick()
     SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_root:isVisible() then
        self.m_root:setVisible(false)
        WindowManager:removeWindow(self.m_root,self,true)
        WndTowerRank:showWindow()
        --WndTowerRank:getRoot():setVisible(true)
    end
end

--@brief 查看每日奖励
function WndTowerPreview:onDailyReward()
     SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if not self.m_root:isVisible() then
        --self.m_root:setVisible(true)
        --WndTowerRank:getRoot():setVisible(false)
    end
end

--@brief	动画播完后的回调
function WndTowerPreview:onActionCallBack()
	WindowManager:removeWindow(self.m_root, self, true)
    if WndTowerRank:getRoot() then
        WindowManager:removeWindow(WndTowerRank:getRoot(), WndTowerRank, true)
    end
end

--@brief	开始点击窗口后的回调
--@param	element:窗口绑定的lua表
--@param    pt:坐标点
function WndTowerPreview:onTouchBegan(element, pt)
    WndItemInfo:onCloseClick()
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndTowerPreview:onClickItem(tItem, nTag, tData)
    WZLog("WndTowerPreview:onClickItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	初始化界面
function WndTowerPreview:_initUI()
    if self.m_root == nil then
        return
    end
    self.m_tData = {}
    local playerSex = CacheCenter:getPlayerInfo().sex
    for k,v in pairs(GDatatab_tower_rank_reward) do
        local reward = {}
        reward.rank = v.rank
        reward.id = v.id
        if playerSex == 1 then
            reward.reward_gift = v.reward_girl
        else
            reward.reward_gift = v.reward_boy
        end
        
        table.insert(self.m_tData,reward)
    end
    table.sort(self.m_tData,function (a,b)
        if a.id < b.id then
            return true
        else
            return false
        end
    end)
    self:_updateItemList()
end

function WndTowerPreview:onGet()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)

    WZLog("------------send get tower reward------------------")
end

--@brief	更新奖励列表
function WndTowerPreview:_updateItemList()
    local tbconList = GetElement(self.m_root, "tbconList_WndTowerPreview", WZUITableContainer)
    tbconList:cleanTable()
    tbconList:enableSchedule("_loadItemList")
    self.m_tbconList = tbconList
end


--@brief  分帧加载数据
function WndTowerPreview:_loadItemList(element)
    WZLog("WndTowerPreview:_loadItemList")
    if self.m_nLoadCount <= #self.m_tData then
        local cell,tcell = CellTowerPreview:createElement()
        cell:setTag(self.m_nLoadCount-1)
        self.m_tbconList:setCellElement(cell)
        tcell:setData(self.m_tData[self.m_nLoadCount])
    else
        self.m_nLoadCount = 1
        element:disableSchedule()
    end
    self.m_nLoadCount = self.m_nLoadCount + 1
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Star--------------------------------------
function WndTowerPreview:_adaptLanguage_en()
	GetElement(self.m_root,"txtArms2_WndTowerPreview",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtArms_WndTowerPreview",WZUILabelTTF):setFontSize(16)
end

function WndTowerPreview:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtArms2_WndTowerPreview",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtArms_WndTowerPreview",WZUILabelTTF):setFontSize(20)
end

function WndTowerPreview:_adaptLanguage_vn()
    GetElement(self.m_root,"txtArms2_WndTowerPreview",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtArms_WndTowerPreview",WZUILabelTTF):setFontSize(16)
end

function WndTowerPreview:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtArms2_WndTowerPreview",WZUILabelTTF):setFontSize(16)
end

function WndTowerPreview:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtArms2_WndTowerPreview",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtArms_WndTowerPreview",WZUILabelTTF):setFontSize(20)
end
-------------------------------------语言适配模块End--------------------------------------
