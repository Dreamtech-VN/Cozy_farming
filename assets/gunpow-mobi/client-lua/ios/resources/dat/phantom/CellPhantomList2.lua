--CellPhantomList2.lua
--@brief	CellPhantomList2的UI模块
--@date		2017/12/22
--@author	zsq
--@note		皮肤列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPhantomList2:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPhantomList2:onExit(element)
	self:_unInit()
end

function CellPhantomList2:onEnterTransitionDidFinish(element)

end

function CellPhantomList2:setData(tData)
	WZLog("CellPhantomList2:setData")
	self.m_tData = tData
	self:update1()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellPhantomList2:update1()
	GetElement(self.m_root,"constatus1",WZUIContainer):setVisible(true)
	local tFetter = GDatatab_fetters["id_"..self.m_tData.fetter_id]
	GetElement(self.m_root,"txtName",WZUILabelTTF):setText(tFetter.name)

	--属性
	for i=1,#tFetter.attribute do
		local tt = tFetter.attribute[i]
		GetElement(self.m_root,"txtAttr"..i,WZUILabelTTF):setText(ATTR_TITLE[tt[1]].."+"..tt[2])
	end

	local active = true
	for i=1,#self.m_tData.content do
		local find = false
		local con = GetElement(self.m_root,"con"..i.."_status1",WZUIContainer)
		for k,v in pairs(GDatatab_shape_skins) do
			if v.channel == self.m_tData.content[i] then
				--已拥有
				if v.own then
					local cellElement,tCell
					cellElement,tCell = CellPhantom:createElement()
					tCell:setData(v)
					cellElement:setScale(0.68)
					con:removeAllChildrenWithCleanup(true)
					con:addChild(cellElement)
					if v.remainTime ~= -1 then
						active = false
					end
					find = true
					break
				end
			end
		end

		if not find then
			for k,v in pairs(GDatatab_shape_skins) do
				if v.channel == self.m_tData.content[i] then
					if not v.own then
						--未拥有
						if v.initial == 1 then
							local cellElement,tCell
							cellElement,tCell = CellPhantom:createElement()
							tCell:setData(v)
							cellElement:setScale(0.68)
							con:removeAllChildrenWithCleanup(true)
							con:addChild(cellElement)
							active = false
						end
					end
				end
			end
		end
	end
	WZLog("CellPhantomList:update3", tFetter.name, active)

	if active then
		GetElement(self.m_root,"txtStatus",WZUILabelTTF):setText("("..LocalStrings.STAR_SOUL_HAVED_ACTIVE..")")
		GetElement(self.m_root,"txtStatus",WZUILabelTTF):setColor(ccc3(99,255,95))
	else
		GetElement(self.m_root,"txtStatus",WZUILabelTTF):setText("("..LocalStrings.STAR_SOUL_NOT_ACTIVE..")")
		GetElement(self.m_root,"txtStatus",WZUILabelTTF):setColor(ccc3(128,122,100))
	end
end



-------------------------------------私有方法模块End----------------------------------------

function CellPhantomList2:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtName",WZUILabelTTF):setScale(0.5)
	GetElement(self.m_root,"txtName",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(160))
	GetElement(self.m_root,"txtAttr1",WZUILabelTTF):setScale(0.5)
	GetElement(self.m_root,"txtAttr2",WZUILabelTTF):setScale(0.5)
	GetElement(self.m_root,"txtAttr3",WZUILabelTTF):setScale(0.5)
	GetElement(self.m_root,"txtStatus",WZUILabelTTF):setScale(0.5)
end

function CellPhantomList2:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtName",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtName",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(130))
	GetElement(self.m_root,"txtAttr1",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtAttr2",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtAttr3",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtStatus",WZUILabelTTF):setScale(0.7)
end

function CellPhantomList2:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtName",WZUILabelTTF):setScale(0.5)
	GetElement(self.m_root,"txtName",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(160))
	GetElement(self.m_root,"txtAttr1",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtAttr2",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtAttr3",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtStatus",WZUILabelTTF):setScale(0.7)
end

function CellPhantomList2:_adaptLanguage_pt(  )
	local txtName = GetElement(self.m_root,"txtName",WZUILabelTTF)
	txtName:setScale(0.55)
	txtName:setDimensions(GlobalMethod:CCSize(150))
	GetElement(self.m_root,"txtAttr1",WZUILabelTTF):setScale(0.55)
	GetElement(self.m_root,"txtAttr2",WZUILabelTTF):setScale(0.55)
	GetElement(self.m_root,"txtAttr3",WZUILabelTTF):setScale(0.55)
	GetElement(self.m_root,"txtStatus",WZUILabelTTF):setScale(0.55)
end

function CellPhantomList2:_adaptLanguage_es(  )
	local txtName = GetElement(self.m_root,"txtName",WZUILabelTTF)
	txtName:setScale(0.55)
	txtName:setDimensions(GlobalMethod:CCSize(150))
	GetElement(self.m_root,"txtAttr1",WZUILabelTTF):setScale(0.55)
	GetElement(self.m_root,"txtAttr2",WZUILabelTTF):setScale(0.55)
	GetElement(self.m_root,"txtAttr3",WZUILabelTTF):setScale(0.55)
	GetElement(self.m_root,"txtStatus",WZUILabelTTF):setScale(0.55)
end