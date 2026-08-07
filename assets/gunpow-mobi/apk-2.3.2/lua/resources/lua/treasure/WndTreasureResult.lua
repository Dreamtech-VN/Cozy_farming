--WndTreasureResult.lua
--@brief	WndTreasureResult的UI模块
--@date		2020/10/31
--@author	hyx
--@note		寻宝奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTreasureResult:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTreasureResult:onExit(element)
	if self.m_sReward_container then
		doStopAllActions(self.m_sReward_container)
	end
	self:_unInit()
end
function WndTreasureResult:onEnterTransitionDidFinish(element)
	self:setSpineAni()
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end

function WndTreasureResult:actionCallback()
	self:initShow()
end
function WndTreasureResult:initShow()
	self.m_sReward_container = GetElement(self.m_root,"reward_container",WZUIContainer)
	
	if #self.m_tSerachItemId <= 5 then
		for i=1, #self.m_tSerachItemId do
			local key = "id_"..self.m_tSerachItemId[i]
			if GDatatab_item[key] then
		 		delayRun(self.m_sReward_container, i / DEFAULT_FPS,function ()
		 			local num = self.m_tSerachItemNum[i]
					local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		 			local celElement,tLuaObj = CellGoodItem:createElement()
		 			tLuaObj:setCellGoodItem(itemInfo, 17)
					self.m_sReward_container:addChild(celElement)
					tLuaObj:setItemClickFun(WndTreasureResult,self.onTreasureSerachItemClick)
					celElement:setScale(0.9)
					celElement:setUseAbsCoordinate(true)
					local _x = (220 + #self.m_tSerachItemId * 45) - (i * 45) - (i-1)*40
					local _y = 50
					celElement:setAbsPosition(GlobalMethod:ccp(_x,_y))
		 		end)
		 	end
		 end
	else
		for i=1, #self.m_tSerachItemId do
			local key = "id_"..self.m_tSerachItemId[i]
			if GDatatab_item[key] then
		 		delayRun(self.m_sReward_container, i / DEFAULT_FPS,function ()
		 			local num = self.m_tSerachItemNum[i]
					local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		 			local celElement,tLuaObj = CellGoodItem:createElement()
		 			tLuaObj:setCellGoodItem(itemInfo, 17)
					self.m_sReward_container:addChild(celElement)
					tLuaObj:setItemClickFun(WndTreasureResult,self.onTreasureSerachItemClick)
					celElement:setScale(0.9)
					celElement:setUseAbsCoordinate(true)
					local _x = 50 + ((i-1)%5) * 85
					local _y = 120 - (math.floor((i-1)/5) * 85)
					celElement:setAbsPosition(GlobalMethod:ccp(_x,_y))
		 		end)
		 	end
	 	end
	 end
end
function WndTreasureResult:onTreasureSerachItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndTreasureResult.m_root,1,tData,false,nil,true)
end
function WndTreasureResult:showInterface(item_id, item_num)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local result = WndTreasureResult:createElement()
	if result ~= nil then
	    WindowManager:addWindow(result,WndTreasureResult,nil,false)
	end
	self:setTreasureResultData(item_id, item_num)
end

function WndTreasureResult:onBtnClickConfirm()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    设置开箱特效
function WndTreasureResult:setSpineAni()
    local spineLight = GetElement(self.m_root, "spineLight_WndTreasureResult", WZUISpine)
    local spinePath = "ui/otherUI/Ui_hd_pic_xb_jl"
    local bIsExist = CheckEffectFile(spinePath)

    if bIsExist then 
        spineLight:setFileJson(spinePath .. ".json")
        spineLight:setFileAtlas(spinePath .. ".atlas")
        spineLight:play("wait_1", true)
    end
 end




-------------------------------------私有方法模块End----------------------------------------
