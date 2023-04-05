using eZamjena;
using eZamjena.Filters;
using eZamjena.Model.SearchObjects;
using eZamjena.Services;
using eZamjena.Services.Database;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

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
builder.Services.AddTransient<IService<eZamjena.Model.Uloga, BaseSearchObject>, BaseService<eZamjena.Model.Uloga, Uloga, BaseSearchObject >>();
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
//builder.Services.AddDbContext<Ib190019Context>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

var app = builder.Build();


// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
