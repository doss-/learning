from time import strftime, gmtime

def test():
  stream = open('/test/file.txt', 'a')
  stream.write("{}: output from container \n".format(strftime("%d %H:%M:%S", gmtime())))
  stream.close()

if __name__ == "__main__":
  test()

