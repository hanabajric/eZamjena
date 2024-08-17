using Models;

namespace eZamjena.Services
{
    public interface IEmailSender
    {
        Task SendEmailAsync(Email email);
    }
}
