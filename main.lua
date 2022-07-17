WINDOW_HEIGHT=500
WINDOW_WIDTH=720
VIRTUAL_HEIGHT=243
VIRTUAL_WIDTH=432
push=require 'push'
gamestate='main_menu'
servingPlayer=2
timer=0
Class=require 'clases'
require 'pelota'
require 'Paleta'
GAME_DIFFICULTY='HARD'

function love.load()
    text=love.graphics.newImage("images/text.png")
    love.graphics.setDefaultFilter('nearest', 'nearest')  
    smallfont=love.graphics.newFont("fonts/font.ttf", 8)
    math.randomseed(os.time())   
    largefont=love.graphics.newFont("fonts/normal.otf",30)
    medfont=love.graphics.newFont("fonts/normal.otf",15)
    player1=Paddle(-1,10,20,'w','s',true)
    player2=Paddle(1,VIRTUAL_WIDTH-15,VIRTUAL_HEIGHT-50,'up','down',true)
    ball=Ball(VIRTUAL_WIDTH/2-4,VIRTUAL_HEIGHT/2-4)
    sound={
        pit = love.audio.newSource("sound/pit.wav", 'static'),
        score = love.audio.newSource("sound/score.wav", 'static'),
        wall = love.audio.newSource("sound/wall_hit.wav", 'static'),
        music= love.audio.newSource("sound/music.mp3",'static')
    }
end

function love.keyreleased(key)
  
    if key=='enter' or key=='return' then
        if gamestate=='start' then
            gamestate='serve'
        elseif gamestate=='serve' then
            gamestate='play'
        elseif gamestate=='victory' then
            gamestate='serve'
            player1.score=0;
            player2.score=0;          
        end
    end
end

function love.update(dt)
    timer=timer+dt
    if timer>1 then
        timer=0
    end
    if gamestate=='play' or gamestate=='serve' then
        player1:update(dt,ball.dx<0 and true or false)
        player2:update(dt,ball.dx>0 and true or false)
        
    end
    if gamestate =='play' then
        if (ball:collides(player1)) then
            ball.dx=-ball.dx*1.05
            sound.pit:play()
            ball.x=player1.x+Paleta_W
            if ball.dy<0 then
                ball.dy=-math.random(10,50)
            else 
                ball.dy=math.random(10,50)
            end
            ball.predicty=ball:predictPosition(player2,1)   
            player2:setOffset()         
        end
        if (ball:collides(player2)) then
            ball.dx=-ball.dx*1.05
            sound.pit:play()            
            ball.x=player2.x-ball.width
            if ball.dy<0 then
                ball.dy=-math.random(10,50)
            else 
                ball.dy=math.random(10,50)
            end
            ball.predicty=ball:predictPosition(player1,-1)                        
            player1:setOffset()                     
        end

        ball:update(dt)
       -- colision con pared vertical
        if (ball.y<0) then
            ball.dy= -ball.dy * 1.02           
            sound.wall:play()
            ball.y=0
        elseif ball.y>VIRTUAL_HEIGHT-5 then
            ball.y=VIRTUAL_HEIGHT-5
            ball.dy=-ball.dy*1.02
            sound.wall:play()
        end
       -- colision para detectar si gano o no
        if ball.x<0 then
            player2.score=player2.score+1
            gamestate='serve'
            sound.score:play()
            servingPlayer=1
            ball=Ball(VIRTUAL_WIDTH/2-4,VIRTUAL_HEIGHT/2-4)            
        elseif ball.x>VIRTUAL_WIDTH then
            player1.score=player1.score+1
            sound.score:play()            
            gamestate='serve'
            servingPlayer=2            
            ball=Ball(VIRTUAL_WIDTH/2-4,VIRTUAL_HEIGHT/2-4)                        
        end
    elseif gamestate=='serve' then
        if servingPlayer==1 then
            ball.dx=math.random(150,200)
        else
            ball.dx=-math.random(150,200)            
        end
    end
end

function love.draw()
    if gamestate=='main_menu' then
        main_menu();

    else
        push:apply('start')
        love.graphics.clear(0.1,0.1,0.1)
        ball:render()
        player1:render()
        player2:render()
        love.graphics.rectangle("fill", 0,-1, VIRTUAL_WIDTH, 3)
        love.graphics.rectangle("fill",0,VIRTUAL_HEIGHT-3, VIRTUAL_WIDTH, 3)
        love.graphics.setFont(medfont)
        lineadelmedio(20,11)
        if player1.score == 10 then
          GAME_DIFFICULTY = 'HARD'
        elseif player1.score == 15 then
            love.graphics.setFont(medfont)
            love.graphics.setColor(0,1,0)        
            love.graphics.printf("Felicidades Ganaste",0,15,VIRTUAL_WIDTH,'center')
            gamestate='victory'
            love.graphics.setFont(smallfont)
            love.graphics.setColor(1,1,1)        
            love.graphics.printf("Preciona ENTER para iniciar otro juego :D",0,35,VIRTUAL_WIDTH,'center')        
        elseif player2.score == 15 then
            love.graphics.setFont(medfont)
            love.graphics.setColor(0,1,0)        
            love.graphics.printf("GAME OVER",0,15,VIRTUAL_WIDTH,'center')
            love.graphics.setColor(255,255,255)
            love.graphics.setFont(smallfont)
            love.graphics.printf("Preciona ENTER para iniciar otro juego :(",0,35,VIRTUAL_WIDTH,'center')        
            gamestate='victory'
        end
        if gamestate=='start' then
            love.graphics.setFont(medfont)
            love.graphics.setColor(1,1,0);
            love.graphics.printf("Bienvenido a Pong!",0,15,VIRTUAL_WIDTH,'center')
            love.graphics.setColor(255,255,255)
            love.graphics.setFont(smallfont)
            love.graphics.printf("Presiones ENTER para jugar",0,35,VIRTUAL_WIDTH,'center')
        elseif gamestate=='serve' then
              gamestate='play'
            
        end
        love.graphics.setFont(largefont)
        love.graphics.print(tostring(player1.score),VIRTUAL_WIDTH/2-60,VIRTUAL_HEIGHT/2-50)
        love.graphics.print(tostring(player2.score),VIRTUAL_WIDTH/2+50,VIRTUAL_HEIGHT/2-50)
        push:apply('end')
    
    end
end

function lineadelmedio(line_height,gap_height)
    for y=0,VIRTUAL_HEIGHT,line_height+gap_height do
        love.graphics.line(VIRTUAL_WIDTH/2-2,y,VIRTUAL_WIDTH/2-2,y+line_height)
    end
end

function love.resize(w, h)
    push:resize(w,h)
end

function main_menu()
    sound.music:play()
    sound.music:setLooping(true)
    draw_fondo() 
    love.graphics.setColor(0.2,0.2,0.2)
    love.graphics.setColor(1,1,1) 
    love.graphics.draw(text,116,-20,0,0.8,0.8)      
    love.graphics.setNewFont("fonts/normal.otf",14)   
    love.graphics.print(" Click para iniciar el juego ",210,450-70,0,1.2,1.2)
   
end

--funcion para dibujar el fondo
function draw_fondo()
    love.graphics.setColor(0.7,0.7,0.7) 
    red = 231/255
    green = 181/255
    blue = 69/255
    color = { red, green, blue}
    love.graphics.setBackgroundColor( color)
    
end

--para detectar el click de la pantalla iniciar
function love.mousereleased(x,y,click)
    if click==1 then
          --para elegir la dificulta de juego e iniciar
                player1.ai,player2.ai=false,true
                GAME_DIFFICULTY='MEDIUM'
                gamestate='start'
                push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT)
            
        end
end