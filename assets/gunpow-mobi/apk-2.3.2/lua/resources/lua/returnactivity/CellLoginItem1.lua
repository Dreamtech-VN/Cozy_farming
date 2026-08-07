--CellLoginItem1.lua
--@brief	CellLoginItem1的UI模块
--@date		2021/05/20
--@author	hyx
--@note		回归活动累登子项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLoginItem1:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLoginItem1:onExit(element)
	self:_unInit()
end
function CellLoginItem1:onEnterTransitionDidFinish(element)
	local data = self.m_tLoginItem1Data
	if data then
		GetElement(self.m_root,"txtLoginDay",WZUILabelTTF):setText(string.format(LocalStrings.SingInDAYS,data.id))
		GetElement(self.m_root,"btnGet",WZUIButton):setVisible(data.status == 0)
		GetElement(self.m_root,"imgGet_Con",WZUIContainer):setVisible(data.status == 1)
		local good_con = GetElement(self.m_root,"good_con",WZUIContainer)
		local items = GDatatab_item["id_"..data.reward[1][1]]
		if items then
			local celElement, tNewObj = CellGoodItem:createElement()
			good_con:addChild(celElement)
		    local itemInfo = {id=i, name=items.name,icon=items.icon,lastNum=data.reward[1][2],quality=items.quality,basicInfo=CopyTable(items)}
		    tNewObj:setCellGoodItem(itemInfo,17)
		    tNewObj:setItemClickFun(WndReturnActivityMain,self.onItemClick)

		    if data.status == 0 then
			    local spine = WZUISpine:create()
			   	spine:setTouchEnable(false)
			   	spine:setFileJson("ui/ui_common_JJLQ.json")
			   	spine:setFileAtlas("ui/ui_common_JJLQ.atlas")
			   	spine:setUseOriginSize(true)
			   	spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
				spine:play("wait_1",true)
			   	celElement:addChild(spine,1)
			   	self.m_sGetSpine = spine
			end
		end
	end
end

function CellLoginItem1:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndReturnActivityMain.m_root,1,tData,false,nil,true)
end

function CellLoginItem1:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tLoginItem1Data then
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivityId,self.m_tLoginItem1Data.id)
	end
end
--领取之后的处理
function CellLoginItem1:onLoginItem1Status()
	if self.m_sGetSpine then
		self.m_sGetSpine:removeFromParentAndCleanup(true)
		self.m_sGetSpine = nil
	end
	if self.m_root then
		GetElement(self.m_root,"btnGet",WZUIButton):setVisible(false)
		GetElement(self.m_root,"imgGet_Con",WZUIContainer):setVisible(true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
