--WndLovingLevelUpgrade.lua
--@brief	WndLovingLevelUpgrade的UI模块
--@date		2015/09/01
--@author	qixiang_xie
--@note		恩爱等级升级提示UI


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLovingLevelUpgrade:onEnter(element)
	self.m_root = element
end

--弹窗动画
function WndLovingLevelUpgrade:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAction(self.m_root,false,"actionCallback",self)
end

--@brief  弹窗动画结束回调
function WndLovingLevelUpgrade:actionCallback(elem,data)
  self.m_root:enableSchedule("anctionPlayFinish")
  self:_update()
end


function WndLovingLevelUpgrade:onTouchBegan()
	if self.m_bActionFinish then
		WindowManager:removeWindow(self.m_root,self,true,nil)
	end
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLovingLevelUpgrade:onExit(element)
	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief  动画播放完毕
function WndLovingLevelUpgrade:anctionPlayFinish(element)
	local spLoveUpgrade = GetElement(self.m_root,"spLoveUpgrade_WndLoving",WZUISpine)
	if spLoveUpgrade then
		if spLoveUpgrade:isCurrentAnimationDone() then
			self.m_bActionFinish = true
			element:disableSchedule()
			spLoveUpgrade:setLoop(true)
			spLoveUpgrade:setAnimationName("enaiup_chixu")
		end
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndLovingLevelUpgrade:_update()
	if self.m_root ~= nil then
		DelayCallFunction(function (luaObject)
			if luaObject ~= nil and luaObject.m_root ~= nil then
				GetElement(luaObject.m_root,"imgArrow_WndLogingLevelUpgrade",WZUIImage):setVisible(true)
				GetElement(luaObject.m_root,"txtPreviousLevel_WndLovingLevelUpgrade",WZUILabelTTF):setText("Lv" .. luaObject.m_nPreviousLevel)
	            GetElement(luaObject.m_root,"txtCurLevel_WndLovingLevelUpgrade",WZUILabelTTF):setText("Lv" .. luaObject.m_nCurLevel)
			end
		end,nil,0.5,self)
	end
end



-------------------------------------私有方法模块End----------------------------------------
