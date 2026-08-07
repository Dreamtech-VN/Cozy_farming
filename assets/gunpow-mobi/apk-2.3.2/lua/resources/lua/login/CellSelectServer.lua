--CellSelectServer.lua
--@brief	CellSelectServer的UI模块
--@date		2015/04/29
--@author	binshao
--@note		选择服务器模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSelectServer:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSelectServer:onExit(element)
	self:_unInit()
end

--@brief	快速选择服务器组，对应更新右边显示的服务器
function CellSelectServer:onCheckSelect(element)
	local tag = self.m_root:getTag()
	self.m_tCallBackFunc[2](self.m_tCallBackFunc[1],tag)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数
function CellSelectServer:_update()
    for i = 1, 2 do
        local txtServerName =  GetElement(self.m_root,"txtServerName"..i.."_CellSelectServer",WZUILabelTTF)
        txtServerName:setText( self.m_tData )
    end


end

function CellSelectServer:setSelState(index)
    local checkBox = GetElement(self.m_root,"checkSelect_CellSelectServer",WZUICheckBox)
    checkBox:setCheckIndex(index)
end
-------------------------------------私有方法模块End---------------------------------------


function CellSelectServer:_adaptLanguage_pt(  )
    local txtServerName1 = GetElement(self.m_root,"txtServerName1_CellSelectServer",WZUILabelTTF)
    txtServerName1:setDimensions(GlobalMethod:CCSize(180))
    txtServerName1:setFontSize(18)

    local txtServerName2 = GetElement(self.m_root,"txtServerName2_CellSelectServer",WZUILabelTTF)
    txtServerName2:setDimensions(GlobalMethod:CCSize(180))
    txtServerName2:setFontSize(18)
end


function CellSelectServer:_adaptLanguage_es(  )
    local txtServerName1 = GetElement(self.m_root,"txtServerName1_CellSelectServer",WZUILabelTTF)
    txtServerName1:setDimensions(GlobalMethod:CCSize(180))
    txtServerName1:setFontSize(18)

    local txtServerName2 = GetElement(self.m_root,"txtServerName2_CellSelectServer",WZUILabelTTF)
    txtServerName2:setDimensions(GlobalMethod:CCSize(180))
    txtServerName2:setFontSize(18)
end

function CellSelectServer:_adaptLanguage_en(  )
    local txtServerName1 = GetElement(self.m_root,"txtServerName1_CellSelectServer",WZUILabelTTF)
    txtServerName1:setDimensions(GlobalMethod:CCSize(180))
    txtServerName1:setFontSize(18)

    local txtServerName2 = GetElement(self.m_root,"txtServerName2_CellSelectServer",WZUILabelTTF)
    txtServerName2:setDimensions(GlobalMethod:CCSize(180))
    txtServerName2:setFontSize(18)
end

function CellSelectServer:_adaptLanguage_ug(  )
    local txtServerName1 = GetElement(self.m_root,"txtServerName1_CellSelectServer",WZUILabelTTF)
    txtServerName1:setDimensions(GlobalMethod:CCSize(180))
    txtServerName1:setFontSize(18)

    local txtServerName2 = GetElement(self.m_root,"txtServerName2_CellSelectServer",WZUILabelTTF)
    txtServerName2:setDimensions(GlobalMethod:CCSize(180))
    txtServerName2:setFontSize(18)
end