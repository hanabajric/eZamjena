using eZamjena;
using eZamjena.Filters;
using eZamjena.Model.SearchObjects;
using eZamjena.Services;
using eZamjena.Services.Database;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using Microsoft.AspNetCore.JsonPatch;
using Microsoft.AspNetCore.Mvc.Formatters;
using Microsoft.Extensions.Options;
using eZamjena.Configurations;
using EasyNetQ;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.WebHost.UseUrls("http://*:5238");

builder.Services.AddControllers(x =>
{
    x.Filters.Add<ErrorFilter>();
});

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer(); 

builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "basicAuth" }
            },
            new string[]{}
        }
    });
});

builder.Services.AddTransient<IProizvodService, ProizvodService>();
builder.Services.AddTransient<IKorisnikService, KorisnikService>();
builder.Services.AddTransient<IKupovinaService, KupovinaService>();
builder.Services.AddTransient<IKategorijaProizvodumService, KategorijaProizvodumService>();
builder.Services.AddTransient<IStatusProizvodumService, StatusProizvodumService>();
builder.Services.AddTransient<IOcjenaService, OcjenaService>();
builder.Services.AddTransient<IRazmjenaService, RazmjenaService>();
builder.Services.AddTransient<IStatusRazmjeneService, StatusRazmjeneService>();
builder.Services.AddTransient<IUlogaService, UlogaService>();
builder.Services.AddTransient<IGradService, GradService>();
builder.Services.AddTransient<IListaZeljaProizvodService, ListaZeljaProizvodService>();
builder.Services.AddTransient<IListaZeljaService, ListaZeljaService>();
builder.Services.AddTransient<INotifikacijaProizvodService, NotifikacijaProizvodService>();
builder.Services.AddTransient<IService<eZamjena.Model.Uloga, BaseSearchObject>, BaseService<eZamjena.Model.Uloga, Uloga, BaseSearchObject >>();
builder.Services.AddTransient<IEmailSender, EmailSender>();
builder.Services.AddAutoMapper(typeof(IKorisnikService));

builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

builder.Services.AddAuthorization(options =>
{

    options.AddPolicy("Administrator",
        authBuilder =>
        {
            authBuilder.RequireRole("Administrator");
        });

});
builder.Services.AddAuthorization(options =>
{

    options.AddPolicy("Klijent",
        authBuilder =>
        {
            authBuilder.RequireRole("Klijent");
        });
});



var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<Ib190019Context>(options =>
    options.UseSqlServer(connectionString));



// RabbitMQ configuration
var rabbitMqConfig = builder.Configuration.GetSection("RabbitMQ").Get<RabbitMqConfig>();
builder.Services.AddSingleton(rabbitMqConfig);

//var bus = RabbitHutch.CreateBus($"host={rabbitMqConfig.HostName};username={rabbitMqConfig.UserName};password={rabbitMqConfig.Password};virtualHost={rabbitMqConfig.VirtualHost};port={rabbitMqConfig.Port}");
var bus = RabbitHutch.CreateBus("host=rabbitmq;username=guest;password=guest");


builder.Services.AddSingleton(bus);

// Payment provider configuration
var paymentProviderConfig = builder.Configuration.GetSection("PaymentProvider").Get<PaymentProviderConfig>();
builder.Services.AddSingleton(paymentProviderConfig);

var app = builder.Build();


// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();

}
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "My API V1");
});


app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var database = scope.ServiceProvider.GetService<Ib190019Context>();
    new DBSetup().Init(database);
   new DBSetup().InsertData(database);
}

app.Run();
