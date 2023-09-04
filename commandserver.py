from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess
import time
import random

last_used = 0
cooldown_seconds = 60

class MyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        global last_used
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        
        current_time = time.time()

        if current_time - last_used < cooldown_seconds:
            self.wfile.write(b'WHOAHHH there buddy... slow down and live a little!')
            return

        if self.path == '/give/gift/xxing28':
            # Update last_used time
            last_used = current_time

            # Sending Minecraft command to tmux session named 'minecraft'
            subprocess.run(["tmux", "send-keys", "-t", "minecraft", "/experience add xxing28 1000 points", "C-m"])

            self.wfile.write(b'Sent command to give 1000 XP to xxing28')
        elif self.path == '/give/gift/DavillaMaster':
            last_used = current_time
            # give DavillaMaster levitation effect for a random number of seconds between 5 and 15
            seconds = random.randint(5, 15)
            subprocess.run(["tmux", "send-keys", "-t", "minecraft", "/effect give DavillaMaster minecraft:levitation " + str(seconds), "C-m"])
        else:
            self.wfile.write(b'Invalid path')

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 8000), MyHandler)
    print('Started HTTP server on port 8000')
    server.serve_forever()
