local tbUAD = GameMain:NewMod("BodyInfo");--先注册一个新的MOD模块

local RList = {{"Human", "人族"},{"YGRabbit", "兔妖"},{"YGChicken", "鸡妖"},{"YGWolf", "狼妖"},{"YGSnake", "蛇妖"},{"YGBoar", "猪妖"},{"YGBear", "熊妖"},{"YGTurtle", "龟妖"},{"YGFrog", "蛙妖"},{"YGCat", "猫妖"},{"YGCattle", "牛妖"},{"YGTiger", "虎妖"}}

function tbUAD:OnInit()
	print("BodyInfo init");
end

function tbUAD:OnEnter()
	print("BodyInfo enter");
	--print(CS.XiaWorld.UILogicMgr.Instance:GetHelpDef("BI1"))
	--CS.XiaWorld.UILogicMgr.Instance:GetHelpDef(BI1).Text= "[size=16]412faga4ww[/size][color=#ff0000]dwqRFAE[/color]"
	self:BI()
	self:RSB()

end

function tbUAD:BI()
	local BI1 = ""
	local t = 1
	local AList = PracticeMgr:GetAllGongName()
	for i=0, AList.Count-1 do
		if PracticeMgr:GetGongDef(AList[i]).GongKind == g_emGongKind.Body then
			--功法名
			BI1 = BI1..string.format("[size=16][color=#9e6404]%d.%s[/color][/size]\n",t,PracticeMgr:GetGongDef(AList[i]).DisplayName)
			--初始秘体
				BI1=self:superPartRacePrint(BI1,PracticeMgr:GetGongDef(AList[i]).SuperParts)
			--境界
			for k=0,PracticeMgr:GetGongDef(AList[i]).Stages.Count-1 do
				local tStage = PracticeMgr:GetGongDef(AList[i]).Stages[k]
				BI1=BI1.."  ".."[color=#4D8AB3]"..tStage.DisplayName.."[/color]\n"
				--小瓶颈，理论上只有一个
				for l=0,tStage.Necks.Count-1 do
					local tNeck = tStage.Necks[l]
					BI1=BI1.."    ".. "[color=#55AA55]"..tNeck.DisplayName.."[/color]\n"
					--瓶颈获得秘体
					BI1=self:superPartRacePrint(BI1,tNeck.SuperParts)
				end
			end

			t=t+1
		end
	end
	CS.XiaWorld.UILogicMgr.Instance:GetHelpDef("BI1").Text=BI1
end

function tbUAD:superPartRacePrint(st, sps)
	for j=0,sps.Count-1 do
		st=st.."      [color=#E61A94]"..  PracticeMgr:GetBPSuperPartDef(sps[j]).Prefix..PracticeMgr:GetBPSuperPartDef(sps[j]).Suffix.."[/color]\n        "
		for h=1,#RList do
			local pass = 1
			for n=0,PracticeMgr:GetBPSuperPartDef(sps[j]).Parts.Count-1 do
				if NpcMgr:GetPartNameByBody(NpcMgr:GetRaceDef(RList[h][1]).Body,PracticeMgr:GetBPSuperPartDef(sps[j]).Parts[n].Name) == "未知" then
					pass = 0
					break
				end
			end
			if pass == 1 then
				st=st..RList[h][2].."  "
			end
		end
		st=st.."\n"
	end
	return st
end

function tbUAD:RSB()
	for h=1,#RList do
		CS.XiaWorld.UILogicMgr.Instance:GetHelpDef(string.format("RSB%d",h)).Title=RList[h][2]
		local RSB = "[size=20]"..RList[h][2].."[/size]\n[size=16][color=#9e6404]1.种族秘体[/color][/size]\n"
		--种族秘体
		if NpcMgr:GetRaceDef(RList[h][1]).RaceSuperPart ~= nil then
			RSB=self:raceAbleSuperPartPrint(RSB,NpcMgr:GetRaceDef(RList[h][1]).RaceSuperPart,h)
		end
		local t = 2
		local AList = PracticeMgr:GetAllGongName()
		for i=0, AList.Count-1 do
			if PracticeMgr:GetGongDef(AList[i]).GongKind == g_emGongKind.Body then
				--功法名
				RSB = RSB..string.format("[size=16][color=#9e6404]%d.%s[/color][/size]\n",t,PracticeMgr:GetGongDef(AList[i]).DisplayName)
				--初始秘体
					RSB=self:raceAbleSuperPartPrint(RSB,PracticeMgr:GetGongDef(AList[i]).SuperParts,h)
				--境界
				for k=0,PracticeMgr:GetGongDef(AList[i]).Stages.Count-1 do
					local tStage = PracticeMgr:GetGongDef(AList[i]).Stages[k]
					RSB=RSB.."  ".."[color=#4D8AB3]"..tStage.DisplayName.."[/color]\n"
					--小瓶颈，理论上只有一个
					for l=0,tStage.Necks.Count-1 do
						local tNeck = tStage.Necks[l]
						RSB=RSB.."    ".. "[color=#55AA55]"..tNeck.DisplayName.."[/color]\n"
						--瓶颈获得秘体
						RSB=self:raceAbleSuperPartPrint(RSB,tNeck.SuperParts,h)
					end
				end

				t=t+1
			end
		end
		CS.XiaWorld.UILogicMgr.Instance:GetHelpDef(string.format("RSB%d",h)).Text=RSB
	end
end

function tbUAD:raceAbleSuperPartPrint(st, sps, race)
	for j=0,sps.Count-1 do
		local tempSP="      [color=#E61A94]"..  PracticeMgr:GetBPSuperPartDef(sps[j]).Prefix..PracticeMgr:GetBPSuperPartDef(sps[j]).Suffix.."[/color]\n"
		local pass = 1
		for n=0,PracticeMgr:GetBPSuperPartDef(sps[j]).Parts.Count-1 do
			local tempP = NpcMgr:GetPartNameByBody(NpcMgr:GetRaceDef(RList[race][1]).Body,PracticeMgr:GetBPSuperPartDef(sps[j]).Parts[n].Name)
			if tempP == "未知" then
				pass = 0
				break
			end
			tempSP=tempSP.."        [color=#E61A1A]"..tempP.."[/color]  "
			for m=0,PracticeMgr:GetBPSuperPartDef(sps[j]).Parts[n].Labels.Count-1 do
				local tempLa = PracticeMgr:GetBPSuperPartDef(sps[j]).Parts[n].Labels[m]
				tempSP=tempSP..PracticeMgr:GetBodyQuenchingLabelDef(tempLa.Name). DisplayName.." ("..tempLa.Levels..") "
			end
			tempSP=tempSP.."\n"
		end
		if pass == 1 then
			st=st..tempSP
		end
	end
	return st
end
