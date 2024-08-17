
using Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eZamjena.Services
{
    public interface IEmailBuilder
    {
        public Email BuildNewProductNotificationEmail(string emailAddress, string firstName, string productName, string productLink);
        public Email BuildConfirmationEmail(string emailAddress, string firstName, string confirmationLink);
        public Email BuildPasswordResetEmail(string emailAddress, string firstName, string callbackUrl);
        public Email BuildChangedPasswordNotificationEmail(string emailAddress, string firstName);
    }
}
