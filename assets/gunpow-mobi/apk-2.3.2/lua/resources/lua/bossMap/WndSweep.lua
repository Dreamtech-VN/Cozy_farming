--WndSweep.lua
--@brief	WndSweep2的UI模块
--@date		2014/08/21
--@author	hugozheng
--@note		购买活力面板


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSweep:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end
--@brief onEnter函数执行完成回调
function WndSweep:onEnterTransitionDidFinish(element)
    --弹窗动画
    self:_setStaticText()
    self:_createRewardsItem()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSweep:onExit(element)
	self:_unInit()
end

--@brief 评分调用的函数
--@param
--@note
function WndSweep:onConfirm(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
	ProtocolProcessorGlobal:send_PLAYER2_ReceivePraiseReward()
end

--@brief 关闭调用的函数
--@param
--@note
function WndSweep:onClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	
    WZLog("WndSweep:onClose")
    WindowManager:removeWindow(self.m_root, self, true)
end

function WndSweep:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false,nil,true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	创建显示私聊频道
--@param	tbl:私聊频道的freelist
--@param	nodeData:一条信息
function WndSweep:_setStaticText()
	--创建UI
    GetElement(self.m_root, "txtConfirm_WndSweep", WZUILabelTTF):setText(LocalStrings.STORERATING[1])
--    GetElement(self.m_root, "txtTitle_WndSweep", WZUILabelTTF):setText(LocalStrings.STORERATING[2])
--    GetElement(self.m_root, "txtContext_WndSweep", WZUILabelTTF):setText(LocalStrings.STORERATING[3])
end

--@brief	创建评分奖励
function WndSweep:_createRewardsItem()
	local conReward = GetElement(self.m_root, "conReward_WndSweep", WZUIContainer)
    conReward:removeAllChildrenWithCleanup(true)

    local praiseReward = CacheCenter:getGameParam().praiseReward
    local ids, nums = SplitItemString(praiseReward)
    local nGapping = 0.15
    local posXStart = 0.5 - (#ids - 1) * nGapping
    for i = 1, #ids do
        local celElement,tLuaObj = CellGoodItem:createElement()
        if celElement and tLuaObj then 
            celElement:setRelativePosition(GlobalMethod:ccp(posXStart + (i - 1) * nGapping * 2, 0.65))
            conReward:addChild(celElement)
            tLuaObj:setCellGoodLocalId(tonumber(ids[i]), tonumber(nums[i]), 17)
            tLuaObj:setItemClickFun(self,self.onItemClick)
            tLuaObj:setBackImgFile("ui/gameActivity/common_pic_di_yn.png", nil, nil, GlobalMethod:ccp(0.5, 0.4)) 
            tLuaObj:resetItemNumPt(GlobalMethod:ccp(0.5, -0.03), GlobalMethod:ccp(0.5, 0.5))
            tLuaObj:setQualityFrameVisible(false)
        end
    end
end

-------------------------------------私有方法模块End----------------------------------------
