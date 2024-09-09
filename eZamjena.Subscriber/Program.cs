using EasyNetQ;
using eZamjena.Model.Messages;
using eZamjena.Services;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using System;
using System.Diagnostics;
using System.Net.Mail;
using System.Net;
using eZamjena.Services.Database;
using Microsoft.EntityFrameworkCore;
using AutoMapper;
using eZamjena.Configurations;
using RabbitMQ.Client;

public partial class Program
{
    private static IServiceProvider _serviceProvider;
    private static IConfigurationRoot configuration;
    static void Main(string[] args)
    {
        Console.WriteLine("Hello, World!");
        
        var services = new ServiceCollection();
        ConfigureServices(services);
        var serviceProvider = services.BuildServiceProvider();
        var korisnikService = serviceProvider.GetRequiredService<IKorisnikService>();
        if (korisnikService == null)
        {
            Console.WriteLine("[Error]: KorisnikService not initialized!");
        }
        else
        {
            Console.WriteLine("[Log]: KorisnikService initialized successfully.");
        }
    //    var configuration = new ConfigurationBuilder()
    //.SetBasePath(Directory.GetCurrentDirectory())
    //.AddJsonFile("appsettings.json", optional: true)
    //.Build();
        var emailUsername = Environment.GetEnvironmentVariable("BREVO_SENDER_EMAIL");
        var brevoApiKey = Environment.GetEnvironmentVariable("BREVO_API_KEY");
        var smtpHost = Environment.GetEnvironmentVariable("BREVO_SMTP_HOST");
        var smtpPort = Environment.GetEnvironmentVariable("BREVO_SMTP_PORT");
        Console.WriteLine($"BREVO_API_KEY: {Environment.GetEnvironmentVariable("BREVO_API_KEY")}");
        Console.WriteLine($"BREVO_SENDER_EMAIL: {Environment.GetEnvironmentVariable("BREVO_SENDER_EMAIL")}");
        Console.WriteLine($"BREVO_SENDER_NAME: {Environment.GetEnvironmentVariable("BREVO_SENDER_NAME")}");
        Console.WriteLine($"BREVO_SMTP_HOST: {Environment.GetEnvironmentVariable("BREVO_SMTP_HOST")}");
        Console.WriteLine($"BREVO_SMTP_PORT: {Environment.GetEnvironmentVariable("BREVO_SMTP_PORT")}");

        var bus = RabbitHutch.CreateBus("host=rabbitmq");
        bus.PubSub.SubscribeAsync<ProizvodInserted>("console_printer_queue", msg =>
        {
            Console.WriteLine($"Product activated: {msg.Proizvod.Naziv}");
        });

        bus.PubSub.SubscribeAsync<ProizvodInserted>("email_sender_queue", async msg =>
        {
            Console.WriteLine($"Sending email to: hnbajric@gmail.com");
            await SendEmailAsync("hnbajric@gmail.com", "Hana", msg.Proizvod.Naziv, "http://linkToProduct.com", emailUsername, brevoApiKey, smtpHost, smtpPort);
        });

        bus.PubSub.SubscribeAsync<ProizvodInserted>("email_sender", async msg =>
        {
            int retryCount = 0;
            const int maxRetry = 5;

            while (retryCount < maxRetry)
            {
                try
                {
                    var otherUsers = korisnikService.GetOtherUsers(msg.Proizvod.KorisnikId);
                    Console.WriteLine($"Found {otherUsers.Count()} other users.");
                    foreach (var user in otherUsers)
                    {
                        Console.WriteLine($"Sending email to: {user.Email}");
                        await SendEmailAsync(user.Email, user.Ime, msg.Proizvod.Naziv, "http://linkToProduct.com", emailUsername, brevoApiKey, smtpHost, smtpPort);
                    }
                    break; // uspješno poslano, izlazi iz petlje
                }
                catch (Exception ex)
                {
                    retryCount++;
                    Console.WriteLine($"[Error]: {ex.Message}, retry {retryCount}/{maxRetry}");
                    if (retryCount >= maxRetry)
                    {
                        Console.WriteLine("[Error]: Maximum retry attempts reached. Skipping message.");
                    }
                }
            }
        });

        Console.WriteLine("Listening for messages, press <return> key to close");
        while (true)
        {
            Thread.Sleep(10000);
        }
    }
    public static async Task SendEmailAsync(string recipientEmail, string firstName, string productName, string productLink, string emailUsername, string brevoApiKey, string smtpHost, string smtpPort)
    {
        string basePath = AppDomain.CurrentDomain.BaseDirectory;
        // string templatePath = Path.Combine(basePath, "..", "..", "..", "Templates", "NewProductNotificationTemplate.html");
        string templatePath = Path.Combine("/app", "Templates", "NewProductNotificationTemplate.html");

        Console.WriteLine($"[Log]: Base path for email template: {templatePath}");

        try
        {
            string emailTemplate = File.ReadAllText(templatePath);
            Console.WriteLine("[Log]: Email template loaded successfully");

            emailTemplate = emailTemplate.Replace("{{firstName}}", firstName);
            emailTemplate = emailTemplate.Replace("{{productName}}", productName);
            emailTemplate = emailTemplate.Replace("{{productLink}}", productLink);

            Console.WriteLine("[Log]: Preparing to create SmtpClient...");
            using (var smtpClient = new SmtpClient())
            {
                smtpClient.Host = smtpHost;
                smtpClient.Port = Convert.ToInt32(smtpPort);
                smtpClient.EnableSsl = true;
                smtpClient.Credentials = new NetworkCredential(emailUsername, brevoApiKey);
                smtpClient.Timeout = 120000;
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

                var mailMessage = new MailMessage
                {
                    From = new MailAddress("ezamjena@gmail.com"),
                    Subject = "Novi proizvod u eZamjena aplikaciji",
                    Body = emailTemplate,
                    IsBodyHtml = true,
                };
                mailMessage.To.Add(recipientEmail);

                Console.WriteLine($"[Log]: Sending email to {recipientEmail} via {smtpHost}");
                await smtpClient.SendMailAsync(mailMessage);
                Console.WriteLine("[Log]: Finished sending email");
            }
        }
        catch (SmtpException smtpEx)
        {
            Console.WriteLine($"[SMTP Error]: {smtpEx.Message}");
            if (smtpEx.InnerException != null)
            {
                Console.WriteLine($"[Inner Exception]: {smtpEx.InnerException.Message}");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[General Error]: {ex.Message}");
        }
    }



    public static void ConfigureServices(IServiceCollection services)
    {
        configuration = new ConfigurationBuilder()
    .SetBasePath(Directory.GetCurrentDirectory())
    .AddJsonFile("appsettings.json", optional: true)
    .AddEnvironmentVariables() 
    .Build();

        services.AddSingleton<IConfiguration>(configuration);

        var connectionString = configuration.GetConnectionString("DefaultConnection");
        Console.WriteLine($"[Log]: Connection string: {connectionString}");

        services.AddDbContext<Ib190019Context>(options =>
            options.UseSqlServer(connectionString));

        services.AddScoped<IKorisnikService, KorisnikService>();
        services.AddAutoMapper(typeof(MappingProfile));
    }
}