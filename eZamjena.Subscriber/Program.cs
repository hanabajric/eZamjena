using EasyNetQ;
using eZamjena.Model.Messages;
using eZamjena.Services;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using System;
using System.Diagnostics;
using System.Net.Mail;
using System.Net;
using dotenv.net;
using Models;

class Program
{
    private static IServiceProvider _serviceProvider;
    private static IConfigurationRoot configuration;
    static void Main(string[] args)
    {
        Console.WriteLine("Hello, World!");

        // Učitavanje .env fajla sa datom putanjom
      

        var configuration = new ConfigurationBuilder()
    .SetBasePath(Directory.GetCurrentDirectory())
    .AddJsonFile("appsettings.json", optional: true)
    .Build();

        var emailUsername = configuration["BrevoApi:SenderEmail"];
        var brevoApiKey = configuration["BrevoApi:ApiKey"];
        var smtpHost = "smtp-relay.brevo.com"; // Ako ovo takođe želite iz konfiguracije, dodajte u appsettings.json
        var smtpPort = 587; // Ovo možete takođe staviti u appsettings.json ako varira

        Debug.WriteLine($"Email Username: {emailUsername}");

        Debug.WriteLine($"eApi KEy: {brevoApiKey}");


        var bus = RabbitHutch.CreateBus("host=localhost");
        

       bus.PubSub.SubscribeAsync<ProizvodInserted>("console_printer", msg =>
        {
            Console.WriteLine($"Product activated: {msg.Proizvod.Naziv}");
        });

         bus.PubSub.SubscribeAsync<ProizvodInserted>("email_sender", async msg =>
        {
            Console.WriteLine($"Sending email for : {msg.Proizvod.Naziv}");
            /* var email = emailBuilder.BuildNewProductNotificationEmail("ezamjena@gmail.com", "Recipient Name", msg.Proizvod.Naziv, "http://product-link.com");
             await emailSender.SendEmailAsync(email);*/
            await SendEmailAsync("Novi proizvod je dodan", emailUsername, brevoApiKey, smtpHost, smtpPort);
        });



        Console.WriteLine("Listening for messages, press <return> key to close");
        Console.ReadLine();
    }


    public static async Task SendEmailAsync(string emailBody, string emailUsername, string brevoApiKey, string smtpHost, int smtpPort)
    {
        
        try
        {
           // var userEmail = trenutniKorisnik.Email;
           // Debug.WriteLine("Ovo je email usera " + userEmail);
            using (var smtpClient = new System.Net.Mail.SmtpClient())
            {
                // Konfiguracija SMTP klijenta
                smtpClient.Host = smtpHost;
                smtpClient.Port = Convert.ToInt32(smtpPort);
                smtpClient.EnableSsl = true;
                smtpClient.Credentials = new NetworkCredential(emailUsername, brevoApiKey); // Koristite sigurne metode za čuvanje lozinke
                smtpClient.Timeout = 30000;
                // Kreiranje e-mail poruke
                var mailMessage = new MailMessage
                {
                    From = new MailAddress("ezamjena@gmail.com"),
                    Subject = "Povratne informacije od korisnika",
                    Body = emailBody,
                    IsBodyHtml = true,
                };
                mailMessage.To.Add("hnbajric@gmail.com");

                // Slanje e-mail poruke
                await smtpClient.SendMailAsync(mailMessage);
            }
        }
        catch (SmtpException smtpEx)
        {
            Debug.WriteLine("Greška prilikom slanja e-maila: " + smtpEx.Message);
            Debug.WriteLine($"SMTP Error: {smtpEx.StatusCode}");
            Debug.WriteLine($"Inner Exception: {smtpEx.InnerException?.Message}");
            // Obrada izuzetka SmtpException
        }
        catch (Exception ex)
        {
            Debug.WriteLine("Opći izuzetak: " + ex.Message);
            // Obrada drugih izuzetaka koji nisu SmtpException
        }
        // Možda ćete ovdje htjeti baciti izuzetak ili vratiti informaciju o grešci
    }
}
/*private static void ConfigureServices()
    {
        var services = new ServiceCollection();

        // Add EasyNetQ Bus
        services.AddSingleton<IBus>(RabbitHutch.CreateBus("host=localhost"));

        // Configuration
        var configuration = new ConfigurationBuilder()
            .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
            .AddEnvironmentVariables()
            .Build();

        services.AddSingleton<IConfiguration>(configuration);

        // Register Email Services
        services.AddSingleton<IEmailBuilder, EmailBuilder>();
        services.AddSingleton<IEmailSender, EmailSender>(); // Replace EmailSender with your implementation

        _serviceProvider = services.BuildServiceProvider();
    }
}

*/