--SceneTempServerList.lua
--@brief	SceneTempServerList的UI模块
--@date		2013/12/12
--@author	SuYuan
--@note		方便测试的临时服务器选择界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneTempServerList:onEnter(element)
	WZLog("SceneTempServerList:onEnter")
	self.m_root = element
	self:_moreLan()
	self:openFileData()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneTempServerList:onExit(element)
	self:_unInit()
end

function SceneTempServerList:onTouchBegan(element,pt)
	local conEdit = WZUIContainer:luaTo(self.m_root:getChildElement("conEdit_SceneTempServerList"))
	local size = conEdit:getContentSize()
	local ptA = conEdit:convertToNodeSpace(pt)
	if ptA.x >= 0 and ptA.x <= size.width and ptA.y >= 0 and ptA.y <= size.height then
		WZLog("Touch:::aaa::")
	else
		conEdit:setVisible(false)
		WZUIButton:luaTo(self.m_root:getChildElement("btnAdd_SceneTempServerList")):setTouchEnable(true)
		WZUIButton:luaTo(self.m_root:getChildElement("btnDel_SceneTempServerList")):setTouchEnable(true)
	end
end

--@brief	删除服务器选服文件
function SceneTempServerList:onDelSeverFile()
	self:saveServerFile("")
	self:saveServerFile("")
	self:openFileData()
end

--@brief	服务器选择回调
function SceneTempServerList:onSelectServer(element)
	element = WZUIButton:luaTo(element)
	local tag = element:getTag()
	if tag == 6 then  --进入字体测试界面
		self:showFontTest()
		return 
	end 
	WZLog("选择服务器回调:",tag,self.m_tServer[tag+1].id)
	local serverId = self.m_tServer[tag+1].id
	IPDConnector:setIPDAddr(serverId)
	SceneLoginMgr:showScene(1)
end

--@brief	添加服务器
function SceneTempServerList:onAddSever(element)
	element = WZUIButton:luaTo(element)
	element:setTouchEnable(false)
	local editServer = WZUIEditBox:luaTo(self.m_root:getChildElement("editServer_SceneTempServerList"))
	editServer:setText("")
	editServer:setPlaceHolder("点击输入服务器地址")
	editServer:setTag(1)
	WZUIContainer:luaTo(self.m_root:getChildElement("conEdit_SceneTempServerList")):setVisible(true)
	WZUIButton:luaTo(self.m_root:getChildElement("btnDel_SceneTempServerList")):setTouchEnable(false)
end

--@brief	删除服务器
function SceneTempServerList:onDelSever(element)
	element = WZUIButton:luaTo(element)
	element:setTouchEnable(false)
	local editServer = WZUIEditBox:luaTo(self.m_root:getChildElement("editServer_SceneTempServerList"))
	editServer:setText("")
	editServer:setPlaceHolder("输入删除服务器的序号")
	editServer:setTag(3)
	WZUIContainer:luaTo(self.m_root:getChildElement("conEdit_SceneTempServerList")):setVisible(true)
	WZUIButton:luaTo(self.m_root:getChildElement("btnAdd_SceneTempServerList")):setTouchEnable(false)
end

--@brief	编辑回调
function SceneTempServerList:onReturn(element)
	element = WZUIEditBox:luaTo(element)
	local text = element:getText()
	local tag = element:getTag()
	WZLog("编辑回调:::",tag,text)
	if tag == 1 and text ~= "" then
		self.m_sServerId = text
		element:setTag(2)
		element:setPlaceHolder("点击输入服务器名称")
	elseif tag == 2 and text ~= "" then
		self.m_sServerName = text
		local contableServer = WZUITableContainer:luaTo(self.m_root:getChildElement("contableServer_SceneTempServerList"))
		local con = self:_createBtn(#self.m_tServer,text)
		contableServer:setCellElement(con)
		local temp = {}
		temp.id = self.m_sServerId
		temp.name = text
		table.insert(self.m_tServer,temp)
		self:saveServerFile(json.encode(self.m_tServer))
		element:setTag(1)
		element:setPlaceHolder("点击输入服务器地址")
		WZUIContainer:luaTo(self.m_root:getChildElement("conEdit_SceneTempServerList")):setVisible(false)
		WZUIButton:luaTo(self.m_root:getChildElement("btnAdd_SceneTempServerList")):setTouchEnable(true)
		WZUIButton:luaTo(self.m_root:getChildElement("btnDel_SceneTempServerList")):setTouchEnable(true)
		temp = nil 
		self.m_sServerId = nil
		self.m_sServerName = nil
	elseif tag == 3 then
		if txt ~= "" and tonumber(text) ~= nil and tonumber(text) > 0 and tonumber(text) <= #self.m_tServer then
			local contableServer = WZUITableContainer:luaTo(self.m_root:getChildElement("contableServer_SceneTempServerList"))
			contableServer:removeCellElement(tonumber(text)-1)
			table.remove(self.m_tServer,tonumber(text))
			self:saveServerFile(json.encode(self.m_tServer))
			self:_update()
		end
		WZUIContainer:luaTo(self.m_root:getChildElement("conEdit_SceneTempServerList")):setVisible(false)
		WZUIButton:luaTo(self.m_root:getChildElement("btnAdd_SceneTempServerList")):setTouchEnable(true)
		WZUIButton:luaTo(self.m_root:getChildElement("btnDel_SceneTempServerList")):setTouchEnable(true)
	end
	element:setText("")
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function SceneTempServerList:_update()
	if self.m_root == nil or self.m_tServer == nil or type(self.m_tServer) ~= "table" then
		return 
	end
	local contableServer = WZUITableContainer:luaTo(self.m_root:getChildElement("contableServer_SceneTempServerList"))
	contableServer:cleanTable()
	for i=1,#self.m_tServer do 
		local con = self:_createBtn(i-1,self.m_tServer[i].name)
		contableServer:setCellElement(con)
	end
	
end

function SceneTempServerList:_createBtn(tag,desc)
	desc = desc or ""
	local con = WZUIContainer:create()
	con:setUseAbsSize(true)
	con:setAbsContentSize(GlobalMethod:CCSize(240,66))
	con:setTag(tag)
	local btn = WZUIButton:create()
	local imgNor = WZUI9Image:create()
	imgNor:setFile("common/button/button_2.png")
	local imgSel = WZUI9Image:create()
	imgSel:setFile("common/button/button_2_sel.png")
	local imgNot = WZUI9Image:create()
	imgNot:setFile("common/button/button_4.png")
	btn:setTag(tag)
	btn:setNormalElement(imgNor)
	btn:setSelectElement(imgSel)
	btn:setDisableElement(imgNot)
	btn:setLuaDoneFunctionName("onSelectServer")
	con:addChild(btn)
	local txt = WZUILabelTTF:create()
	txt:setFontSize(36)
	txt:setColor(GlobalMethod:ccc3(255,255,255))
	txt:setTouchEnable(false)
	txt:setText(desc)
	con:addChild(txt)
	return con
end

function SceneTempServerList:_moreLan()
	WZUILabelTTF:luaTo(self.m_root:getChildElement("txtDel_SceneTempServerList")):setText("删除选择服\n务器文件")
end


--modify by wuweidong
function SceneTempServerList:showFontTest(  )
	local conTestFont = GetElement(self.m_root,"conTestFont",WZUIContainer)
	conTestFont:setVisible(true)
	local flFontList = GetElement(self.m_root,"flFontList",WZUIFreeListContainer)
	self.FontListName = {"American typewriter","AmericanTypewriter-Bold","AppleGothic","ArialMT","Arial-BoldMT","Arial-BoldItalicMT","Arial-ItalicMT","ArialHebrew","ArialHebrew-Bold","ArialRoundedMTBold","ArialUnicodeMS","Courier","Courier-Oblique","Courier-Bold","CourierNewPS-BoldMT","CourierNewPS-ItalicMT","CourierNewPS-BoldItalicMT","CourierNewPSMT","DBLCDTempBlack","GeezaPro-Bold","GeezaPro","Georgia-Bold","Georgia","Georgia-BoldItalic","Georgia-Italic","STHeitiJ-Medium","STHeitiJ-Light","STHeitiK-Medium","STHeitiK-Light","STHeitiSC-Medium","STHeitiSC-Light","HeitiTC-Light","HeitiTC-Mediun","Helvetica-Oblique","Helvetica-BoldOblique","Helvetica","Helvetica-Bold","HelveticaNeue","HelveticaNeue-Bold","HiraKakuProN-W6","HiraKakuProN-W3","MarkerFelt-Thin","Thonburi-Bold","Thonburi","TimesNewRomanPSMT","TimeNewRomanPSMT-BoldMT","TimeNewRomanPSMT-BoldItalicMT","TimeNewRomanPSMT-BItalicMT","TrebuchetMS-Italic","TrebuchetMS","TrebuchetMS-BoldItalic","TrebuchetMS-Bold","Verdana-Bold","Verdana-BoldItalic","Verdana-talic","Verdana","Zapfino"}
	for i=1,#self.FontListName do
		local element = self:_createBtnForFont(i,self.FontListName[i])
        flFontList:pushBack(element)
        element:setContentSize(GlobalMethod:CCSize(350,66))
        element:setRelativeSize(GlobalMethod:CCSize(1,66/600))
	end
	flFontList:update()
    flFontList:getMoveElement():setPositionY(flFontList:getMinPosition().y)
end

function SceneTempServerList:onCloseClick( element)
	local conTestFont = GetElement(self.m_root,"conTestFont",WZUIContainer)
	conTestFont:setVisible(false)
end

function SceneTempServerList:_createBtnForFont(tag,desc)
	desc = desc or ""
	local con = WZUIContainer:create()
	con:setUseAbsSize(true)
	con:setAbsContentSize(GlobalMethod:CCSize(350,66))
	con:setTag(tag)
	local btn = WZUIButton:create()
	local imgNor = WZUI9Image:create()
	imgNor:setFile("common/button/button_2.png")
	local imgSel = WZUI9Image:create()
	imgSel:setFile("common/button/button_2_sel.png")
	local imgNot = WZUI9Image:create()
	imgNot:setFile("common/button/button_4.png")
	btn:setTag(tag)
	btn:setNormalElement(imgNor)
	btn:setSelectElement(imgSel)
	btn:setDisableElement(imgNot)
	btn:setLuaDoneFunctionName("onFontTest")
	con:addChild(btn)
	local txt = WZUILabelTTF:create()
	txt:setFontSize(36)
	txt:setColor(GlobalMethod:ccc3(255,255,255))
	txt:setTouchEnable(false)
	txt:setText(desc)
	con:addChild(txt)
	return con
end

function SceneTempServerList:onFontTest( element )
	element = WZUIButton:luaTo(element)
	local tag = element:getTag()
	local txt = self.FontListName[tag]
	local txtTestlabel = GetElement(self.m_root,"txtTestlabel",WZUILabelTTF)
	txtTestlabel:setFont(txt)
end
-------------------------------------私有方法模块End----------------------------------------
