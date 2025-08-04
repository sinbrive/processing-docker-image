'''
sinbrive 2022

'''

BRICK_W = 60
BRICK_H = 10
SPEED = 3
ROW = 3
COLUMN = 6
LIVES = 3
SPACE = 2

class Brick:
    def __init__(self, x, y, w, h, col):
        self.x = x
        self.y = y
        self.w = w
        self.h = h
        self.color = col
        self.isVisible = True
        
    def move(self):
        self.x = mouseX
    
    def draw(self):
        push()
        fill(self.color)
        stroke(150)
        rect(self.x, self.y, self.w, self.h)
        pop()

class Ball:
    def __init__(self, x, y, d):
      self.x = x
      self.y = y
      self.d = d
      self.vx = SPEED
      self.vy = SPEED
      self.dy = 1
      self.dx = 1
      self.col = '#000000'
    
    def stop(self):
      self.vx = 0
      self.vy = 0
    
    def restart(self):
      self.vx = SPEED
      self.vy = -SPEED

    def reverseDY(self):
      self.dy *= -1
    
    def moveXY(self, x, y):
      self.x = x
      self.y = y
    
    def move(self, x=None, y=None):
        if (x is not None) and (y is not None):
            self.x = x
            self.y = y
            return
        self.x += self.vx * self.dx
        self.y += self.vy * self.dy
        
        if self.x >= width or self.x <= 0:
            self.dx *= -1
        
        if self.y <= 0:
            self.dy *= -1
        
    def draw(self):
        fill(self.col)
        ellipse(self.x, self.y, self.d, self.d)

class Game:
    def __init__(self):
        self.bricks = []
        self.game_stopped = True
        self.lives = LIVES
        self.game_over = False
        self.count = ROW * COLUMN
        self.paddle = Brick(width / 2, height - BRICK_H / 2, BRICK_W, BRICK_H, '#000000')
        self.ball = Ball(width / 2, height / 2, 10)
        self.bricks = self.createBricks()

    def createBricks(self):
      arBricks = []
      for y in range(0, ROW * BRICK_H, BRICK_H + SPACE):
          c = hex(int(random(0, 1) * 0xFFFFFF))
          col = "#" + str(c)[2:]
          for x in range(0, COLUMN * BRICK_W, BRICK_W + SPACE):
            b = Brick(x+BRICK_W / 2 + 15, y + BRICK_H, BRICK_W, BRICK_H, col)
            arBricks.append(b)
      return arBricks
    
    def resetBricks(self):
      self.bricks = []
      self.bricks = self.createBricks()
    
    def click(self):
        self.ball.restart()
        self.game_stopped = False
        if self.game_over:
            self.game_over = False
            self.lives = LIVES
    
    def collide(self, b):
        dx = abs(self.ball.x - b.x)
        dy = abs(self.ball.y - b.y)
        return (dx <= b.w / 2) and (dy <= b.h / 2)
    
    def update(self):
        self.paddle.move()
        if self.game_stopped or self.game_over:
            self.ball.move(self.paddle.x, self.paddle.y - 10)
            return
        self.ball.move()
    
        if self.collide(self.paddle):
            self.ball.reverseDY()
        else :
            if self.ball.y > height - 10:
                self.ball.stop()
                self.lives -= 1
                if self.lives == 0:
                    self.resetBricks()
                    self.count = ROW * COLUMN
                    self.game_over = True
                    return
                self.game_stopped = True
                return
    
        for i in range(0, len(self.bricks)):
    
            brick = self.bricks[i]
        
            if brick.isVisible:
    
                if self.collide(brick):
                    brick.isVisible = False
                    self.ball.reverseDY()
                    self.count -= 1
                    if self.count == 0:
                        self.ball.stop()
                        self.resetBricks()
                        self.count = ROW * COLUMN
                        self.game_over = True
                        return
    
    def display(self):
        background(255)
        rect(width / 2, height / 2, width, height)
        push()
        for i in range(0, len(self.bricks)):
            brick = self.bricks[i]
            if brick.isVisible:
                brick.draw()
        self.paddle.draw()
        self.ball.draw()
        fill(150)
        text("Balls: " + str(self.lives), 10, height - 10)
        pop()

def setup():
    global game
    size(400, 300)
    game = Game()
    rectMode(CENTER)

def draw():
    game.update()
    game.display()

def mouseClicked(event):
    game.click()