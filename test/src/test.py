#!/usr/bin/env python2

import pika

def main():
    conn = pika.BlockingConnection()
    chan = conn.channel()
    q = chan.queue_declare()
    chan.basic_publish('', q.method.queue, 'foo')
    _, props, _ = chan.basic_get(q.method.queue)
    assert props.user_id == 'guest'


if __name__ == '__main__':
    main()
