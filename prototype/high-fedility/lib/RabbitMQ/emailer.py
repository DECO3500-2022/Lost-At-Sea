from python_emailer.email_processing import PyMailer

class Emailer:
    def __init__(self, email, password, subject, recepient):
        self.email = email
        self.password = password
        self.subject = subject
        self.recepient = recepient 


class Activation_emailer(Emailer):
    def __init__(self, email, password, subject, recipient, first_name, last_name, activation_code):
        super().__init__(email, password, subject, recipient)
        self.first_name = first_name
        self.last_name = last_name
        self.activation_code = activation_code
    
    def message(self):
        return f"Hi {self.first_name} {self.last_name},\nHere is your Activation Code:\n\n{self.activation_code}\n\nHope to see you soon,\nCobbl"
    
    def send(self):
        PyMailer([self.recepient], [self.email, self.password], self.subject, self.message()).send_email()

if __name__ == "__main__":
    mailer = Activation_emailer(
        'cobbl.activation@gmail.com',
        'INFS3202',
        'Your Activation Code',
        'sites.ad.p3@gmail.com',
        'Adrian',
        'Low',
        '12345'
    )
    mailer.send()