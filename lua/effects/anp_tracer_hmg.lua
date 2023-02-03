-----------------\
-----------------|\
--By Cpt.Hazama--| > http://steamcommunity.com/id/cpthazama/
-----------------|/
-----------------/
EFFECT.Mat = Material( "effects/spark" ) 

function EFFECT:Init(data)

	self.StartPos 	= data:GetStart();
	self.Entity  	= data:GetEntity();
	self.EndPos 	= data:GetOrigin();
	self.Dir 		= self.EndPos - self.StartPos;
	self.Normal 	= self.Dir:GetNormal();
	self.StartTime 	= 0;
	self.LifeTime 	= (self.Dir:Length()+200)/7000;
	
	if (!IsValid(self.Entity)) then return end
	
	local attachment = self.Entity:GetAttachment(data:GetAttachment());
	if(attachment) then
		self.StartPos = attachment.Pos;
	end
	
	self.Entity:SetRenderBoundsWS(self.StartPos, self.EndPos)
	
end

function EFFECT:Think()
if self.LifeTime == nil then return end
	self.LifeTime = self.LifeTime -FrameTime();
	self.StartTime = self.StartTime +FrameTime(); 
return self.LifeTime > 0;
end

function EFFECT:Render()

	local endDistance = 7000*self.StartTime;
	local startDistance = endDistance-200;
	
	startDistance = math.max(0,startDistance);
	endDistance = math.max(0,endDistance);

	local startPos = self.StartPos+self.Normal*startDistance;
	local endPos = self.StartPos+self.Normal*endDistance;
	
	local color = Color(255,255,200,255);
	
	render.SetMaterial(self.Mat);
	render.DrawBeam(startPos,endPos,6,0,1,color);
end

effects.Register( EFFECT, "anp_tracer_hmg" )