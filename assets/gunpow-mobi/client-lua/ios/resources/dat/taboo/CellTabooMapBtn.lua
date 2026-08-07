--CellTabooMapBtn.lua
--@brief	CellTabooMapBtn的UI模块
--@date		2017/04/21
--@note		地图按钮


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTabooMapBtn:onEnter(element)
	self.m_root = element
    self:_updateSize()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTabooMapBtn:onExit(element)
	self:_unInit()
end


--@brief	点击按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function CellTabooMapBtn:onBtnClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("CellTabooMapBtn:onBtnClick")

     SceneTabooBattle:show(self.m_tData.id)
end

--@brief 刷新按钮
function CellTabooMapBtn:updateBtnView()
    GetElement(self.m_root,"btnBuild_CellTabooMapBtn",WZUIButton):setVisible(true)
    local tmp = GDatatab_forbidden_chapter["id_"..self.m_tData.id]
    WZLog("CellTabooMapBtn:updateBtnView",tostring(tmp.level),self.m_tData.id)
    local conCloud = GetElement(self.m_root,"conCloud_CellTabooMapBtn",WZUIContainer)
    GetElement(self.m_root,"labOpenLv_CellTabooMapBtn",WZUILabelTTF):setText(string.format(LocalStrings.UPGRADE_LEVEL_UNREACHED,tmp.level))

    if tmp.level > CacheCenter:getPlayerInfo().level then
        WZLog("CellTabooMapBtn:updateBtnView-2")
        conCloud:setVisible(true)
    else
        conCloud:setVisible(false)
    end
end

--@brief 设置按钮位置
function CellTabooMapBtn:setBtnRelativePosition(pos)
    GetElement(self.m_root,"btnBuild_CellTabooMapBtn",WZUIButton):setRelativePosition(pos)
end

--@brife 显示文本
function CellTabooMapBtn:setOpenLvView(value)
    WZLog("CellTabooMapBtn:setOpenLvView",tostring(value))
    GetElement(self.m_root,"conOpenLv_CellTabooMapBtn",WZUIContainer):setVisible(value)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新界面
function CellTabooMapBtn:_update()
   -- local pathList = {
   --      [1] = "ui/taboo/taboo_jianzhu_01.png",
   --      [2] = "ui/taboo/taboo_jianzhu02.png",
   --  }   
   --  local path = pathList[self.m_tData.id] or pathList[1]
   local template = GDatatab_forbidden_chapter["id_"..self.m_tData.id]
   
    WZLog("CellTabooMapBtn:_update",tostring(self.m_tData.id))
    GetElement(self.m_root,"imgBtnBuildNor_CellTabooMapBtn",WZUIImage):setFile(template.icon)
    GetElement(self.m_root,"imgBtnBuildSel_CellTabooMapBtn",WZUIImage):setFile(template.icon)
    GetElement(self.m_root,"imgName_CellTabooMapBtn",WZUIImage):setFile(template.image)
    self:updateBtnView()
end


--@brief 调整位置
function CellTabooMapBtn:_updateSize()
    local img = GetElement(self.m_root,"imgName_CellTabooMapBtn",WZUIImage)
    local btnSize = GetElement(self.m_root,"imgBtnBuildNor_CellTabooMapBtn",WZUIImage):getContentSize()
    local parentSize = img:getParent():getContentSize()
    local imgSize = img:getContentSize()
    img:setRelativePositionLuaTo(0.5,0.5 - ((btnSize.height/2 - imgSize.height + 10)/parentSize.height))
end
-------------------------------------私有方法模块End----------------------------------------
