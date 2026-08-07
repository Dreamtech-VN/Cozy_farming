--CellLibraryPathName.lua
--@brief	CellLibraryPathName的UI模块
--@date		2016/10/21
--@author	Tianxiang_Xu
--@note		图鉴-获取路径-文字


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLibraryPathName:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLibraryPathName:onExit(element)
	self:_unInit()
end

--@brief    加载
function CellLibraryPathName:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellLibraryPathName")
    self.m_root:addChild(celElement)

    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellLibraryPathName:_update()
    -- body
    local txtPathName = GetElement(self.m_root, "txtPathName_CellLibraryPathName", WZUILabelTTF)
    --WZLog("CellLibraryPathName:_update", Serialize(self.m_tData), type(self.m_tData[2]))
    if txtPathName then
        txtPathName:setText(self.m_tData[2])
    end
end




-------------------------------------私有方法模块End----------------------------------------
