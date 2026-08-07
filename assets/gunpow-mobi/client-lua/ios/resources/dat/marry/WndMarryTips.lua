--WndMarryTips.lua
--@brief	WndMarryTips的UI模块
--@date		2014/01/13
--@author	叶威
--@note		结婚礼堂提示框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMarryTips:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    self:_update()
   
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMarryTips:onExit(element)
	self:_unInit()
end

--@brief	关闭窗口
--@param	element:按钮的引用
function WndMarryTips:onCloseClick(element)
    WZLog("WndMarryTips:onCloseClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if element == nil then
		WZLog("WndMarryTips:onCloseClick(element) element is nil ")
	end
	WindowManager:removeWindow(self.m_root, self, true)
	--刷新婚礼选项
	if WndMarryHoll.m_root ~= nil then
		WndMarryManager:initManager()
	end 
    --移除粒子动画
--[[  local animation =  WindowManager:getSceneRoot():getChildElement(WndMarryManager.animationName.qiuhun5)
    if animation ~= nil then
        WindowManager:getSceneRoot():removeChild(animation,true) 
    end   ]]
end

--@brief    确定按钮响应函数
--@param	element:按钮的引用
function WndMarryTips:onSureClick(element)
    WZLog("WndMarryTips:onSureClick")

    --回调上级窗口注册的函数
    if self.m_callBackLuaObj ~= nil and self.m_callBackLuaFun ~= nil then
        self.m_callBackLuaFun(self.m_callBackLuaObj)
        self:onCloseClick()
    else
        WZLog("WndMarryTips:onSureClick,callBackLuaObj==nil or callBackLuaFun== nil")
        self:onCloseClick()
    end
end

--@brief  播放成功动画
function WndMarryTips:playAnimation()
     -- local element = WZUISystem:getInstance():createElement(WndMarryManager.animationName.qiuhun5)
     -- if element == nil then
     --    WZLog("WndMarryTips:_playAnimation,element == nil")
     -- end
     -- element:setTouchEnable(false)
     -- self.m_root:addChild(element)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新界面
function WndMarryTips:_update()
    self:_showTypeWindow()
end

--@brief 根据窗口类型显示相应界面
function WndMarryTips:_showTypeWindow()
    WZLog("_showTypeWindow")
    local txt = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTips_WndMarryTips"))
    txt:setText(self.m_sText)
    local txtBtnSure = GetElement(self.m_root,"txtBtnSure_WndMarryTip",WZUILabelTTF)
    
    --根据窗口类型，显示背景
    local imgWndBG_WndMarryTip = GetElement(self.m_root, "imgWndBG_WndMarryTip", WZUIImage)
    local btnMarry =  GetElement(self.m_root,"btnMarry_WndMarryTips",WZUIButton)
    local norElement =  btnMarry:getNormalElement()
    local norImage =WZUI9Image:luaTo(norElement:getChildByTag(1))
    local selElement =  btnMarry:getSelectElement()
    local selImage =WZUI9Image:luaTo(selElement:getChildByTag(1))

    local con2Particale =  GetElement(self.m_root,"con2Particale_WndMarryTips",WZUIContainer)
    if self.m_nWindowType == WndMarryTips.wndType.WEDDING_OK then 
        txtBtnSure:setStrokeColor(GlobalMethod:ccc3(128,54,13))
        norImage:setFile("ui/common/common_btn_marryan.png")
        selImage:setFile("ui/common/common_btn_marryan.png")
        imgWndBG_WndMarryTip:setFile(self.m_sTipImgPath)
        con2Particale:setVisible(true)
    elseif self.m_nWindowType == WndMarryTips.wndType.WEDDING_FAILD then
        txtBtnSure:setStrokeColor(GlobalMethod:ccc3(26,42,172))
        norImage:setFile("ui/common/common_btn_marryan2.png")
        selImage:setFile("ui/common/common_btn_marryan2_sel.png")
        imgWndBG_WndMarryTip:setFile(self.m_sTipImgPath)
    end
end

-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------
function WndMarryTips:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtTips_WndMarryTips",WZUILabelTTF):setFontSize(24)
end

function WndMarryTips:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtBtnSure_WndMarryTip",WZUILabelTTF):setFontSize(22)
end

function WndMarryTips:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtBtnSure_WndMarryTip",WZUILabelTTF):setFontSize(22)
end
-------------------------------------语言适配模模块End----------------------------------------