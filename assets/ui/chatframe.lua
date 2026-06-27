
function ChatInputBox_OnEnterPressed()
	local editbox = getglobal("ChatInputBox");

	local text = ChatInputBox:GetText();
	ChatInputBox:AddStringToHistory(text);
	ClientCurGame:sendChat(text);
	ChatInputBox:Clear();
	ChatInputFrame:Hide();
	ClientCurGame:setOperateUI(false);

	UIFrameMgr:setCurEditBox(nil);
end

function ChatContentFrame_OnLoad()
	this:RegisterEvent("GE_UPDATE_CHATMSG");	
end

ChatDisplayTime = 0
function ChatContentFrame_OnEvent()
	if arg1 == "GE_UPDATE_CHATMSG" then
		if IsHideUI then
			this:Hide();
		else
			local ge = GameEventQue:getCurEvent();

			local chattype = ge.body.chat.chattype;
			local speaker = ge.body.chat.speaker;
			local content = ge.body.chat.content;

			if chattype==0 or chattype==1 then
				systips = getglobal( "ChatContentText" );
				if speaker == "" then
					systips:AddText(content, 255, 255, 255);
				else
					systips:AddText("#A003".."[".."#L"..speaker.."@@@" .."#n]".."˵:"..content, 255, 255, 0); 
				end
				systips:SetDispPos(systips:GetStartDispPos());

				maxviewlines = systips:GetAccurateViewLines()
				nNum = systips:GetTextLines() - maxviewlines

				systips:SetDispPos(systips:GetStartDispPos());
				for i = 1, nNum do
					systips:ScrollDown();
				end
			end

			this:Show();
			ChatDisplayTime = 5.0
		end
	end
end

function ChatContentFrame_OnUpdate()
	ChatDisplayTime = ChatDisplayTime - arg1
	if ChatDisplayTime <= 0 then
		this:Hide();
	end
end

function Accelkey_AltGroup( szFrame, nIndex )
end
