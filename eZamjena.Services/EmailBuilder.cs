using Microsoft.Extensions.Configuration;
using Models;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Text.Encodings.Web;
using System.Threading.Tasks;

namespace eZamjena.Services
{
    public class EmailBuilder : IEmailBuilder
    {
        private readonly IConfiguration _configuration;

        public EmailBuilder(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public Email BuildNewProductNotificationEmail(string emailAddress, string firstName, string productName, string productLink)
{
    var email = new Email();

    string logoPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Templates", "logo.jpg");
    string emailTemplatePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Templates", "NewProductNotificationTemplate.html");

    string emailTemplate = File.ReadAllText(emailTemplatePath);
    byte[] logoImageArray = File.ReadAllBytes(logoPath);
    string base64ImageRepresentation = Convert.ToBase64String(logoImageArray);

    emailTemplate = emailTemplate.Replace("{{productName}}", productName);
    emailTemplate = emailTemplate.Replace("{{productLink}}", productLink);
    emailTemplate = emailTemplate.Replace("{{firstName}}", firstName);
    emailTemplate = emailTemplate.Replace("{{momentumLogo}}", base64ImageRepresentation);
    emailTemplate = emailTemplate.Replace("{{momentumLink}}", "https://yourwebsite.com"); //Replace with real values

    email.Subject = $"Discover Our New Product: {productName}";
    email.ReceiverEmail = emailAddress;
    email.ReceiverName = firstName;
    email.SenderEmail = "hnbajric@gmail.com"; // Change this to your sender email
    email.SenderName = "eZamjena"; // Change this to your sender name
    email.EmailBody = emailTemplate;

    return email;
}

        public Email BuildConfirmationEmail(string emailAddress, string firstName, string confirmationLink)
        {
            var email = new Email();

            email.Subject = "Complete Your Registration";
            email.ReceiverEmail = emailAddress;
            email.ReceiverName = firstName;
            email.SenderEmail = _configuration["BrevoApi:SenderEmail"];
            email.SenderName = _configuration["BrevoApi:SenderName"];
            email.EmailBody = CreateConfirmationEmailBody(firstName, confirmationLink);

            return email;
        }

        public Email BuildPasswordResetEmail(string emailAddress, string firstName, string callbackUrl)
        {
            var email = new Email();

            string logoPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Templates", "logo.jpg");
            string emailTemplatePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Templates", "ForgotPasswordEmailTemplate.html");

            string emailTemplate = File.ReadAllText(emailTemplatePath);
            byte[] logoImageArray = File.ReadAllBytes(logoPath);
            string base64ImageRepresentation = Convert.ToBase64String(logoImageArray);

            emailTemplate = emailTemplate.Replace("{{callbackUrl}}", callbackUrl);
            emailTemplate = emailTemplate.Replace("{{firstName}}", firstName);
            emailTemplate = emailTemplate.Replace("{{momentumLogo}}", base64ImageRepresentation);
            emailTemplate = emailTemplate.Replace("{{momentumLink}}", "https://testic.com"); //Replace with real values

            email.Subject = "Reset Your Password";
            email.ReceiverEmail = emailAddress;
            email.ReceiverName = firstName;
            email.SenderEmail = _configuration["BrevoApi:SenderEmail"];
            email.SenderName = _configuration["BrevoApi:SenderName"];
            email.EmailBody = emailTemplate;

            return email;
        }

        public Email BuildChangedPasswordNotificationEmail(string emailAddress, string firstName)
        {
            var email = new Email();

            string emailTemplatePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Templates", "ChangedPasswordNotification.html");

            string emailTemplate = File.ReadAllText(emailTemplatePath);

            emailTemplate = emailTemplate.Replace("{{firstName}}", firstName);
            emailTemplate = emailTemplate.Replace("{{dateAndTime}}", DateTime.UtcNow.ToString());

            email.Subject = "Reset Your Password";
            email.ReceiverEmail = emailAddress;
            email.ReceiverName = firstName;
            email.SenderEmail = _configuration["BrevoApi:SenderEmail"];
            email.SenderName = _configuration["BrevoApi:SenderName"];
            email.EmailBody = emailTemplate;

            return email;
        }

        private static string CreateConfirmationEmailBody(string firstName, string confirmationLink)
        {
            string logoPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Templates", "logo.jpg");
            string emailTemplatePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Templates", "ConfirmationEmailTemplate.html");

            string emailTemplate = File.ReadAllText(emailTemplatePath);
            byte[] logoImageArray = File.ReadAllBytes(logoPath);
            string base64ImageRepresentation = Convert.ToBase64String(logoImageArray);

            emailTemplate = emailTemplate.Replace("{{verificationLink}}", confirmationLink);
            emailTemplate = emailTemplate.Replace("{{firstName}}", firstName);
            emailTemplate = emailTemplate.Replace("{{momentumLogo}}", base64ImageRepresentation);
            emailTemplate = emailTemplate.Replace("{{momentumLink}}", "https://testic.com"); //Replace with real values

            return emailTemplate;
        }


    }
}
