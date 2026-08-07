--CellCardBoxItem.lua
--@brief	CellCardBoxItem的UI模块
--@date		2016/07/26
--@author	Tianxiang_Xu
--@note		卡牌系统-卡套


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCardBoxItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCardBoxItem:onExit(element)
	self:_unInit()
end

--@brief    加载cell的数据信息
function CellCardBoxItem:onLoadData( ... )
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellCardBoxItem")
    self.m_root:addChild(celElement)

    self.m_bIsLoad = true

    AdaptLanguage(self)
    self:_update()
end

--@brief    点击卡套回调
function CellCardBoxItem:onClickCardBox(element)
    -- body
    local tag = self.m_root:getTag()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1],element,tag, self.m_tData)
    end
end

--@brief    获取卡套Id
function CellCardBoxItem:getCardBoxId()
    -- body
    return self.m_tData.id
end

function CellCardBoxItem:updateChoose(isBool)
    -- body
    WZLog("设置选中框")
    self.m_bIsChoose = isBool
    if self.m_bIsLoad == true then
        local imgChoose = GetElement(self.m_root,"imgChoose_CellCardBoxItem",WZUI9Image)
        imgChoose:setVisible(isBool)
    end
end

--@brief    设置卡套数量
function CellCardBoxItem:setNumber(num)
    -- body
    self.m_tData.number = num 
    if self.m_root == nil then return end 

    local txtNumber = GetElement(self.m_root, "txtNumber_CellCardBoxItem", WZUILabelTTF)
    txtNumber:setText(num)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新cell信息
function CellCardBoxItem:_update()
    -- body
    --卡套图标
    local imgIcon = GetElement(self.m_root, "imgIcon_CellCardBoxItem", WZUIImage)
    local imgSection = GetElement(self.m_root, "imgSection_CellCardBoxItem", WZUIImage)
    if self.m_tData.section == -1 then
        imgIcon:setFile(self.m_tData.icon)
        imgSection:setVisible(false)
    else
        imgIcon:setFile(string.format("ui/card/kapai_icon_book%d.png", self.m_tData.basicInfo.quality))
        --章节
        imgSection:setFile(string.format("ui/card/kapai_icon_zj%d.png", self.m_tData.section))
    end
    --卡套名字
    local txtName = GetElement(self.m_root, "txtName_CellCardBoxItem", WZUILabelTTF)
    txtName:setText(self.m_tData.basicInfo.name)
    txtName:setColor(QUALITYCOLOR[self.m_tData.basicInfo.quality])
    --数量
    local txtNumber = GetElement(self.m_root, "txtNumber_CellCardBoxItem", WZUILabelTTF)
    txtNumber:setText(self.m_tData.number)
    --选中框
    local imgChoose = GetElement(self.m_root,"imgChoose_CellCardBoxItem",WZUI9Image)
    imgChoose:setVisible(self.m_bIsChoose)
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------------语言适配Begin-------------------------------------
function CellCardBoxItem:_adaptLanguage_en(  )
    local txt = GetElement(self.m_root,"txtName_CellCardBoxItem",WZUILabelTTF)
    txt:setFontSize(18)
    txt:setDimensions(GlobalMethod:CCSize(170,0))
    txt:setRelativePosition(GlobalMethod:ccp(0.5,0.86))
end

function CellCardBoxItem:_adaptLanguage_pt(  )
    local txt = GetElement(self.m_root,"txtName_CellCardBoxItem",WZUILabelTTF)
    txt:setFontSize(18)
    txt:setDimensions(GlobalMethod:CCSize(170,0))
    txt:setRelativePosition(GlobalMethod:ccp(0.5,0.86))
end

function CellCardBoxItem:_adaptLanguage_th(  )
    local txt = GetElement(self.m_root,"txtName_CellCardBoxItem",WZUILabelTTF)
    txt:setFontSize(18)
    txt:setDimensions(GlobalMethod:CCSize(170,0))
    txt:setRelativePosition(GlobalMethod:ccp(0.5,0.86))
end

function CellCardBoxItem:_adaptLanguage_vn()
    WZLog("CellCardBoxItem:_adaptLanguage_vn")
    local txt = GetElement(self.m_root,"txtName_CellCardBoxItem",WZUILabelTTF)
    txt:setFontSize(18)
    txt:setDimensions(GlobalMethod:CCSize(170,0))
    txt:setRelativePosition(GlobalMethod:ccp(0.5,0.86))
end

function CellCardBoxItem:_adaptLanguage_tr()
    WZLog("CellCardBoxItem:_adaptLanguage_tr")
    local txt = GetElement(self.m_root,"txtName_CellCardBoxItem",WZUILabelTTF)
    txt:setFontSize(18)
    txt:setDimensions(GlobalMethod:CCSize(170,0))
    txt:setRelativePosition(GlobalMethod:ccp(0.5,0.86))
end

function CellCardBoxItem:_adaptLanguage_es(  )
    local txt = GetElement(self.m_root,"txtName_CellCardBoxItem",WZUILabelTTF)
    txt:setFontSize(14)
    txt:setDimensions(GlobalMethod:CCSize(170,0))
    txt:setRelativePosition(GlobalMethod:ccp(0.5,0.86))
end

function CellCardBoxItem:_adaptLanguage_ug(  )
    local txt = GetElement(self.m_root,"txtName_CellCardBoxItem",WZUILabelTTF)
    txt:setScale(0.7)
    txt:setDimensions(GlobalMethod:CCSize(260,0))
    txt:setRelativePosition(GlobalMethod:ccp(0.5,0.86))
end
-------------------------------------------语言适配End---------------------------------------