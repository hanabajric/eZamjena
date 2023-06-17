using eZamjena.Model.Utils;
using System.Net.Http.Headers;
using System.Text;

namespace eZamjena.Utils
{
    public static class CredentialsParser
    {
        public static Credentials ParseCredentials(HttpRequest request)
        {
            var authHeader = AuthenticationHeaderValue.Parse(request.Headers["Authorization"]);
            var credentialBytes = Convert.FromBase64String(authHeader.Parameter);
            var credentials = Encoding.UTF8.GetString(credentialBytes).Split(':');

            var username = credentials[0];
            var password = credentials[1];

            return new Credentials() { Username = username, Password = password };
        }
    }
}
