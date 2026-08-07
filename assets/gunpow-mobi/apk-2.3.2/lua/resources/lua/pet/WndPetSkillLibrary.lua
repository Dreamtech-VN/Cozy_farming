--WndPetSkillLibrary.lua
--@brief	WndPetSkillLibrary的UI模块
--@date		2017/11/20
--@author	zsq
--@note		宠物技能图鉴


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPetSkillLibrary:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

function WndPetSkillLibrary:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
	self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPetSkillLibrary:onExit(element)
	self:_unInit()
end

function WndPetSkillLibrary:show() 
	WZLog("WndPetSkillLibrary:show")
    local wnd = WndPetSkillLibrary:createElement()
    WindowManager:addWindow(wnd, WndPetSkillLibrary)
end

function WndPetSkillLibrary:onClose(element) 
	WZLog("WndPetSkillLibrary:onClose")
  	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
	
	WndPetsSkill:playAttackAni()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPetSkillLibrary:_update() 
	WZLog("WndPetSkillLibrary:_update")
	local conFree = GetElement(self.m_root,"conFree_WndPetSkillLibrary",WZUITableContainer)
	conFree:cleanTable()
	local index = 0
	for i=60000,69999 do
		local t = GDatatab_skill["id_"..i]
		if t ~= nil then
			local lv = tonumber(string.sub(t.lv_icon,-5,-5))
			if lv == 5 then
				local celElement,tCell = CellPetSkillLibrary:createElement()
				if celElement ~= nil and tCell ~= nil then 
					celElement:setTag(index)
					celElement = WZUIContainer:luaTo(celElement)
					tCell:setData(t)
					conFree:setCellElement(celElement)
					index=index+1
				end 
			end
		end
	end
	conFree:getMoveElement():setPositionY(conFree:getMinPosition().y)
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function WndPetSkillLibrary:_adaptLanguage_ug( )
	local txtTipsName = GetElement(self.m_root,"txtTipsName_WndSelectTipsStrengthen",WZUILabelTTF)
	txtTipsName:setScale(0.75)
	txtTipsName:setDimensions(GlobalMethod:CCSize(400))
	txtTipsName:setRelativePosition(GlobalMethod:ccp(0.5,0.410112))
end
-------------------------------------语言适配End----------------------------------------
