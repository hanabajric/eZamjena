using Microsoft.Extensions.Configuration;
using Models;
using sib_api_v3_sdk.Api;
using sib_api_v3_sdk.Model;
using System.Diagnostics;
using Task = System.Threading.Tasks.Task;

namespace eZamjena.Services
{
    public class EmailSender : IEmailSender
    {
        private readonly IConfiguration _configuration;

        public EmailSender(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task SendEmailAsync(Email email)
        {
            var apiInstance = new TransactionalEmailsApi();

            var receiver = new SendSmtpEmailTo(email.ReceiverEmail, email.ReceiverName);
            List<SendSmtpEmailTo> receivers = new List<SendSmtpEmailTo>
            {
                receiver
            };

            var sender = new SendSmtpEmailSender(email.SenderName, email.SenderEmail);
            string htmlMessage = email.EmailBody;

            var sendSmtpEmail = new SendSmtpEmail(sender, receivers, null, null, htmlMessage, null, email.Subject); 

            try
            {
                // Send a transactional email
                apiInstance.SendTransacEmail(sendSmtpEmail);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling TransactionalEmailsApi.SendTransacEmail: " + e.Message);
            }
        }
    }
}
