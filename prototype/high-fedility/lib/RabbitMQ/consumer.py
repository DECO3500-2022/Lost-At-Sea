import pika, sys, os
import ast
import emailer

CONF_EMAIL = 'cobbl.activation@gmail.com'
CONF_PASSWORD = 'INFS3202'
CONF_SUBJECT = 'Your Activation Code'


def main(queue):
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
    channel = connection.channel()

    channel.queue_declare(queue='emailer', durable=True)

    def callback(ch, method, properties, body):
        print(" [x] Received %r" % body)
        data = ast.literal_eval(body.decode("UTF-8"))
        send_email(CONF_EMAIL, CONF_PASSWORD, CONF_SUBJECT, data['email'], data['first_name'], data['last_name'], data['register_code'])

    channel.basic_consume(queue='emailer', on_message_callback=callback, auto_ack=True)

    print(' [*] Waiting for messages. To exit press CTRL+C')
    channel.start_consuming()

def send_email(email, password, subject, recepient, first_name, last_name, register_code):
    emailer.Activation_emailer(email, password, subject, recepient, first_name, last_name, register_code).send()

if __name__ == '__main__':
    try:
        main('emailer')
    except KeyboardInterrupt:
        print('Interrupted')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)