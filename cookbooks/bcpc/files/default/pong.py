#!/usr/bin/env python

import socket
import fcntl
import struct
import array
import SocketServer
import threading
import ConfigParser

servers = {}

def closeall() :
    for network, srv in servers: 
        print "closing " + network + " server"
        srv.shutdown()

class PingPongHandler(SocketServer.BaseRequestHandler) :
    
    def handle(self):
        self.data = self.request.recv(4)
        if data == "PING" : 
          self.request.sendall("PONG")
        elif data == "EXIT" : 
          self.request.sendall("Exit received. Shutting down")
          closeall()

class PingPongServer(SocketServer.ThreadingMixIn, SocketServer.TCPServer) :
    pass           


def listen(network, ipaddr, port) :
    print "Starting server for network " + network
    server = PingPongServer((ipaddr, port), PingPongHandler)
    server_thread = threading.Thread(target=servers[network].serve_forever)
    server_thread.daemon = True
    server_thread.start() 
    servers[network] = (server, server_thread)
	

def all_interfaces():
    max_possible = 128  # arbitrary. raise if needed.
    bytes = max_possible * 32
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    names = array.array('B', '\0' * bytes)
    outbytes = struct.unpack('iL', fcntl.ioctl(
        s.fileno(),
        0x8912,  # SIOCGIFCONF
        struct.pack('iL', bytes, names.buffer_info()[0])
    ))[0]
    namestr = names.tostring()
    lst = []
    for i in range(0, outbytes, 40):
        name = namestr[i:i+16].split('\0', 1)[0]
        ip   = namestr[i+20:i+24]
        lst.append((name, ip))
    return lst

def format_ip(addr):
    return str(ord(addr[0])) + '.' + \
           str(ord(addr[1])) + '.' + \
           str(ord(addr[2])) + '.' + \
           str(ord(addr[3]))

def 

ifs = all_interfaces()
for i in ifs:
    print "%12s   %s" % (i[0], format_ip(i[1]))

    start_servers()
    
    test_remotes()    

    for network, srv in servers: 
        server, thread = srv
        thread.join()
