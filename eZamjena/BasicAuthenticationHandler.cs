using eZamjena.Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;
using eZamjena.Services.Database;
using eZamjena.Model.Utils;
using eZamjena.Utils;

namespace eZamjena

{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>

    {
        public IKorisnikService KorisnikService  { get; set; }
       // public Ib190019Context Context { get; set; }
        public BasicAuthenticationHandler(Ib190019Context context,IKorisnikService korisnikService, IOptionsMonitor<AuthenticationSchemeOptions> options, ILoggerFactory logger, UrlEncoder encoder, ISystemClock clock)
        : base(options, logger, encoder, clock)
        {
            KorisnikService = korisnikService;
           // Context = context;
        }


        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.ContainsKey("Authorization"))
            {
                return AuthenticateResult.Fail("Missing auth header");
            }

            Credentials credentials = CredentialsParser.ParseCredentials(Request);
            var user =await   KorisnikService.Login(credentials.Username, credentials.Password);

            //var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
            //var credentialsBytes = Convert.FromBase64String(authHeader.Parameter);
            //var credentials = Encoding.UTF8.GetString(credentialsBytes).Split(':');

            //var username = credentials[0];
            //var password = credentials[1];

            //var user= KorisnikService.Login(username,password);

            if (user == null)
            {
                return AuthenticateResult.Fail("Incorrect username or password");
            }

            var claims = new List<Claim>
        {
            new Claim(ClaimTypes.NameIdentifier, credentials.Username),
            new Claim(ClaimTypes.Name, user.Ime)
        };
            var ulogaID = user.UlogaID;
           // var entity = Context.Ulogas.Where(x => x.Id == ulogaID).FirstOrDefault();
            //System.Console.WriteLine("Naziv uloge-> " + entity.Naziv);
            claims.Add(new Claim(ClaimTypes.Role, user.Uloga.Naziv));
            System.Console.WriteLine("Naziv uloge-> " + user.Uloga.Naziv);//Administrator
            //claims.Add(new Claim(ClaimTypes.Role, entity.Naziv ));

            System.Console.WriteLine("CLAIMS -> " + claims.Any());

            var identity = new ClaimsIdentity(claims, Scheme.Name);
            var principal = new ClaimsPrincipal(identity);

            var ticket = new AuthenticationTicket(principal, Scheme.Name);

            return AuthenticateResult.Success(ticket);
        }
    }
}
