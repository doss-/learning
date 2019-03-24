import time

import redis
from flask import Flask

app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379)

def get_hit_count1():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redit.Exceptions.ConnectionError as exc:
            if retrues == 0:
               raise exc
            retries -= 1
            time.sleep(0.5)

@app.route('/')
def hello_w():
    count = get_hit_count1()
    return ': Hello World! I have been seen {} times.\n'.format(count)   

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
