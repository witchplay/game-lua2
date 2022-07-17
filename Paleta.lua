Paddle=Class{}
Paleta_S=300
Paleta_W=5
Paleta_H=23

function Paddle:init (pos,x,y,c1,c2,ai)
    self.pos=pos
    self.x=x
    self.y=y
    self.keyup=c1
    self.keydown=c2
    self.ai=ai
    self.score=0
    self:setOffset();       
    self.dir=math.random(2)==1 and -1 or 1
end

function Paddle:render()
    love.graphics.rectangle('fill',self.x,self.y,Paleta_W,Paleta_H)
end

function Paddle:update(dt,defend)
    if self.ai== false then
        if (love.keyboard.isDown(self.keyup)) then
            self.y=math.max(0,self.y-Paleta_S*dt)
        elseif (love.keyboard.isDown(self.keydown)) then
            self.y=math.min(VIRTUAL_HEIGHT-20,self.y+Paleta_S*dt)
        end
    else

        if defend == false then
            self.y=self.y+Paleta_S*self.dir*dt;
        elseif gamestate=='play' then
            if self.pos>0 and ball.x+BALL_WIDTH+self.offset>=self.x then
                ball.predicty=ball.y
            elseif self.pos<0 and ball.x-self.offset<=self.x then
                ball.predicty=ball.y
            end
            if not (ball.predicty>=self.y and ball.predicty<=self.y+Paleta_H) then
                if ball.predicty<self.y then
                    self.dir=-1 
                elseif ball.predicty>self.y+Paleta_H then
                    self.dir=1 
                end
                self.y=self.y+Paleta_S*self.dir*dt;
            end
        end
        if self.y<0 or self.y+Paleta_H>VIRTUAL_HEIGHT then
            self.dir=-self.dir
        end
    end
end

function Paddle:setOffset()
    if GAME_DIFFICULTY=='HARD' then
        self.offset=math.random(200,300)
    elseif GAME_DIFFICULTY=='MEDIUM' then
        self.offset=math.random(100,200)  
    end 
end