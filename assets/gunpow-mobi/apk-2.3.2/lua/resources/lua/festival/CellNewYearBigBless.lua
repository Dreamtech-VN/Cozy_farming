--CellNewYearBigBless.lua
--@brief	CellNewYearBigBless的UI模块
--@date		2021/01/08
--@author	hyx
--@note		祈福大奖


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewYearBigBless:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewYearBigBless:onExit(element)
	if self.m_root then 
		self.m_root:disableSchedule()
	end
	self:_unInit()
end
function CellNewYearBigBless:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function CellNewYearBigBless:actionCallback()
	local good_con = GetElement(self.m_root,"good_con",WZUIContainer)
	local items = GDatatab_item["id_"..self.m_tBigBlessReward.id]
	if items then
		local celElement, tNewObj = CellGoodItem:createElement()
		good_con:addChild(celElement)
	    local itemInfo = {id=i, name=items.name,icon=items.icon,lastNum=self.m_tBigBlessReward.num,quality=items.quality,basicInfo=items}
	    tNewObj:setCellGoodItem(itemInfo,17)
	    tNewObj:setItemClickFun(self,self.onItemClick)
	end

	local conFireWork = GetElement(self.m_root, "conFireWork_CellNewYearBigBless", WZUIContainer)
    conFireWork:removeAllChildrenWithCleanup(true)
	self.m_nFirePlayNum = 10
	self:showFireWork()
	self.m_root:enableSchedule("showFireWork", 0.3)
end
function CellNewYearBigBless:onItemClick(tCell,tag,tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndItemInfo:showInfo(tCell.m_root,CellNewYearBigBless.m_root,1,tData,false,nil,true)	
end
function CellNewYearBigBless:showInterface(reward)
	local wndBigBless = CellNewYearBigBless:createElement(reward)
	if wndBigBless then
	    WindowManager:addWindow(wndBigBless,CellNewYearBigBless,nil,false)
	end
end

function CellNewYearBigBless:onBtnClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 不放烟花
function CellNewYearBigBless:showFireWork()
	-- body
	if self.m_nFirePlayNum <= 0 then 
		self.m_root:disableSchedule()
		return 
	end
	local fireworkType = 2
	local totalNum = math.random(1+math.floor(fireworkType*0.4),3+math.floor(fireworkType*0.4))
    --礼炮播放的随机位置
	local salutePs = {{0.230729,0.889865},{0.486205,0.619292},{0.736896,0.846371},{0.602471,0.71346},{0.753787,0.39232},
                  {0.207926,0.378596},{0.591752,0.110117},{0.451009,0.866956},{0.229314,0.637555},{0.483102,0.334784}}

    WZLog("CellNewYearBigBless:showFireWork", fireworkType)
    local conFireWork = GetElement(self.m_root, "conFireWork_CellNewYearBigBless", WZUIContainer)
    local animationName = {"redEnvelope03","redEnvelope04","redEnvelope05"}

    if conFireWork then
    	for i=1,totalNum do
		    local element2 = WZUISystem:getInstance():createElement(animationName[fireworkType])
			element2:setVisible(false)
		    element2:setTouchEnable(true)
			local index = math.random(1,2)
			local par = GetElement(element2,"particle"..index,WZUIParticle)
			par:setVisible(true)
			local indexPs = math.random(1,10)
		    local ps = salutePs[indexPs]
		    element2:setRelativePosition(GlobalMethod:ccp(ps[1],ps[2]))
		    conFireWork:addChild(element2)
			element2:setVisible(true)
	    end
    end

    self.m_nFirePlayNum = self.m_nFirePlayNum - 1
end




-------------------------------------私有方法模块End----------------------------------------
