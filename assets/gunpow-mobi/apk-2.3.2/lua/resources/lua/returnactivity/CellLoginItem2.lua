--CellLoginItem2.lua
--@brief	CellLoginItem2的UI模块
--@date		2021/05/20
--@author	hyx
--@note		回归活动累登子项2


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLoginItem2:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLoginItem2:onExit(element)
	self:_unInit()
end

function CellLoginItem2:onEnterTransitionDidFinish(element)
	local data = self.m_tLoginItem2Data
	if data then
		GetElement(self.m_root,"txtLoginDay",WZUILabelTTF):setText(string.format(LocalStrings.SingInDAYS,data.id))
		GetElement(self.m_root,"btnGet",WZUIButton):setVisible(data.status == 0)
		GetElement(self.m_root,"imgGet_Con",WZUIContainer):setVisible(data.status == 1)
		if #data.reward > 3 then
			for i=1,6 do
				local good_con = GetElement(self.m_root,"good_con"..i,WZUIContainer)
				local ptx, pty
				local idx = (i-1)%3+1
				if idx == 1 then
					ptx = 0.2
				elseif idx == 2 then
					ptx = 0.5
				elseif idx == 3 then
					ptx = 0.8
				end
				if i <= 3 then
					pty = 0.615
				elseif i <= 6 then
					pty = 0.305
				end
				if data.reward[i] then
					good_con:setRelativePosition(GlobalMethod:ccp(ptx, pty))
					good_con:setScale(0.65)
					good_con:setVisible(true)
					local items = GDatatab_item["id_"..data.reward[i][1]]
					local celElement, tNewObj = CellGoodItem:createElement()
					good_con:addChild(celElement)
					local itemInfo = {id=i, name=items.name,icon=items.icon,lastNum=data.reward[i][2],quality=items.quality,basicInfo=CopyTable(items)}
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
						self.m_sGetSpine[i] = spine
					end
				end
			end
		else
			for i=1,3 do
				local good_con = GetElement(self.m_root,"good_con"..i,WZUIContainer)
				if data.reward[i] then
					good_con:setScale(1)
					good_con:setVisible(true)
					local items = GDatatab_item["id_"..data.reward[i][1]]
					local celElement, tNewObj = CellGoodItem:createElement()
					good_con:addChild(celElement)
					local itemInfo = {id=i, name=items.name,icon=items.icon,lastNum=data.reward[i][2],quality=items.quality,basicInfo=CopyTable(items)}
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
						self.m_sGetSpine[i] = spine
					end
				end
			end
			for i=4,6 do
				local good_con = GetElement(self.m_root,"good_con"..i,WZUIContainer)
				good_con:setVisible(false)
			end
		end
		local txtDesc = GetElement(self.m_root,"txtDesc",WZUILabelTTF)
		txtDesc:setText("")
		local is_wing,is_clothes = nil,nil
		for i=1,#data.reward do
			local items = GDatatab_item["id_"..data.reward[i][1]]
			if items then
				if items.main_type == 5 and items.sub_type == 3 then
					is_wing = true
					break
				elseif items.main_type == 3 and items.sub_type == 0 then
					is_clothes = true
					break
				end
			end
		end
		if is_wing == true then
			txtDesc:setText(LocalStrings.ACTIVITY_TEXT30)
		elseif is_clothes == true then
			txtDesc:setText(LocalStrings.ACTIVITY_TEXT31)
		end
	end
end

function CellLoginItem2:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndReturnActivityMain.m_root,1,tData,false,nil,true)
end

function CellLoginItem2:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tLoginItem2Data then
		CellLoginReward:showInterface(self.m_nActivityId,self.m_tLoginItem2Data)
	end
end
--领取之后的处理
function CellLoginItem2:onLoginItem2Status()
	for i,v in pairs(self.m_sGetSpine) do
		if v then
			v:removeFromParentAndCleanup(true)
			v = nil
		end
	end
	if self.m_root then
		GetElement(self.m_root,"btnGet",WZUIButton):setVisible(false)
		GetElement(self.m_root,"imgGet_Con",WZUIContainer):setVisible(true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
