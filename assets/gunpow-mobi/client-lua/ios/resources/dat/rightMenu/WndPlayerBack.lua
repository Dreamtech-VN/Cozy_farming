--WndPlayerBack.lua
--@brief	WndPlayerBack的UI模块
--@date		2017/02/14
--@author	maopeiting
--@note		老玩家回归奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPlayerBack:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPlayerBack:onExit(element)
	self:_unInit()
end

function WndPlayerBack:showWindow(  )
	self:_update()
end

--@brief 	领奖按钮被点击事件
function WndPlayerBack:onClick( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.status == -1 then --不可领取
		MsgBoxManager:showTipBox(LocalStrings.PLAYERBACK1)
	elseif self.status == 0 then --可领取
		--背包已满提示
    	if CacheCenter:getRemainAmount() <= 0 then
        	MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        	return
    	end
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.activityId,self.rewardId[1])
		GetElement(self.m_root,"btnReward_WndPlayerBack",WZUIButton):setVisible(false)
		GetElement(self.m_root,"imgReward_WndPlayerBack",WZUIImage):setVisible(true)
	end
end

--@brief 	规则按钮被点击事件
function WndPlayerBack:onDes( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WndSingleMapDesc:showInterface(LocalStrings.PLAYERBACK3)
end

function WndPlayerBack:_update(  )
	local startDate = os.date("*t", self.startDate)
    local endDate = os.date("*t", self.endTime)
    local txtTimeWords = GetElement(self.m_root, "txtActivity_WndPlayerBack", WZUILabelTTF)
    txtTimeWords:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":")
    local txtTime = GetElement(self.m_root, "txtTime_WndPlayerBack", WZUILabelTTF)
    txtTime:setText(string.format(LocalStrings.ACTIVITYTIME_FORMAT, startDate.month, startDate.day, startDate.hour, startDate.min, endDate.month, endDate.day, endDate.hour, endDate.min))
    GetElement(self.m_root,"txtDes_WndPlayerBack",WZUILabelTTF):setText(string.format(LocalStrings.PLAYERBACK2,self.day))
    if #self.rewardId > 0 then
    	for i=1,#self.rewardId do
            local item = GDatatab_item["id_"..self.rewardId[i]]
    		--for k,v in pairs(GDatatab_item) do
    			--if v.id == self.rewardId[i] then
    		local itemInfo = {id = item.id, name=item.name,icon=item.icon,lastTime=self.itemCount[i],quality=item.quality,basicInfo=CopyTable(item)}
			local celElement,tCell = CellGoodItem:createElement()
			if celElement and tCell ~= nil then
				celElement:setTag(i-1)
				tCell:setCellGoodItem(itemInfo,4)
				tCell:setItemClickFun(self,self.onTips)
				GetElement(self.m_root,"con"..i.."_WndPlayerBack",WZUIContainer):addChild(celElement)
				--break
			end
    			--end
    		--end
    	end
    else
    	GetElement(self.m_root,"txtNoReward_WndPlayerBack",WZUILabelTTF):setVisible(true)
    	GetElement(self.m_root,"btnReward_WndPlayerBack",WZUIButton):setVisible(false)
    end
    if self.status == 1 then
    	GetElement(self.m_root,"imgReward_WndPlayerBack",WZUIImage):setVisible(true)
    	GetElement(self.m_root,"btnReward_WndPlayerBack",WZUIButton):setVisible(false)
    end
end

function WndPlayerBack:onTips( tCell,tag,tData )
	WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@获得奖励
function WndPlayerBack:ACTIVITY_ReceiveActivityRewardOk(itemsId,count)
	WZLog("WndPlayerBack:ACTIVITY_ReceiveActivityRewardOk")
    if self.m_root == nil then
    	WZLog("self.m_root is nil!")
        return
    end
    WndRewardShow:showById(itemsId,count)
    WndRewardShow:closeCallBack(self,self._GetRewardOk, _G, pushEquipInList)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin------------------------------------------
function WndPlayerBack:_adaptLanguage_vn(  )
    GetElement(self.m_root, "txtActivity_WndPlayerBack", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.2,0.475))
    GetElement(self.m_root, "txtBtnReward_WndPlayerBack", WZUILabelTTF):setScale(0.7)
end

-------------------------------------语言适配End--------------------------------------------