from PIL import Image
from io import BytesIO
import os, random, time, sys, requests

imgDir = "database/img/"
nowDir = os.getcwd() + "/"

def crop(imgPath, x1, y1, x2, y2, outImg):
  img = Image.open(imgPath, "r")
  img.crop([x1, y1, x2, y2]).convert('RGB').save(outImg)
  return

def download(url, path):
  r = requests.get(url)
  if r.status_code != 200:
    return
  byte_stream = BytesIO(r.content)
  im = Image.open(byte_stream)
  if im.mode == "RGBA":
    im.load()  # required for png.split()
    background = Image.new("RGB", im.size, (255, 255, 255))
    background.paste(im, mask=im.split()[3])
  im.save(path, 'PNG')

def guessAvatar(path, outImg):
  img = Image.open(path, "r")
  h, w = img.size
  x1 = h - h // 4
  y1 = w - w // 4
  x1 = random.randint(0, x1 - 1)
  y1 = random.randint(0, y1 - 1)
  crop(path, x1, y1, x1 + h // 4, y1 + w // 4, outImg)

if __name__ == "__main__":
  random.seed(time.time() // 1)
  if not os.path.exists(imgDir):
    os.makedirs(imgDir)
  outImg = nowDir + imgDir + str(time.time()) + ".jpg"
  if sys.argv[1] == "crop":
    crop(sys.argv[2], eval(sys.argv[3]), eval(sys.argv[4]), eval(sys.argv[5]), eval(sys.argv[6]), outImg)
    print(outImg)
  if sys.argv[1] == "download":
    download(sys.argv[2], sys.argv[3])
  if sys.argv[1] == "guessAvatar":
    guessAvatar(sys.argv[2], outImg)
    print(outImg)
