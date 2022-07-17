Ball=Class {}

BALL_WIDTH= 5
BALL_HEIGHT= 5

function Ball:init(x,y)
    self.x=x
    self.y=y
    self.width=5
    self.height=5
    self.dx=(math.random(0,1)==1) and 100 or -100
    self.dy=math.random(-50,50)
    
    if self.dx<0 then
        self.predicty=self:predictPosition(player1,-1)
    else
        self.predicty=self:predictPosition(player2,1)
    end
end

function Ball:update(dt)
    self.x=self.x + self.dx*dt;
    self.y=self.y + self.dy*dt;
end

function Ball:render()
    love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)
end

function Ball:collides(paddle)
    if self.x > paddle.x + Paleta_W or self.y > paddle.y + Paleta_H or paddle.x > self.x+self.width or paddle.y >self.y+self.height then
        return false
    else
        return true
    end
end 

function Ball:predictPosition(paddle)
    
    if paddle.pos < 0 then
        return math.abs(((self.x-paddle.x-Paleta_W)/self.dx)*self.dy)
    else
        return math.abs(((paddle.x-self.x-BALL_WIDTH)/self.dx)*self.dy)
    end
    
end        