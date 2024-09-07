using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eZamjena.Services.Migrations
{
    /// <inheritdoc />
    public partial class InitialMigration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Grad",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Grad", x => x.ID);
                });

            migrationBuilder.CreateTable(
                name: "KategorijaProizvoda",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KategorijaProizvoda", x => x.ID);
                });

            migrationBuilder.CreateTable(
                name: "StatusProizvoda",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StatusProizvoda", x => x.ID);
                });

            migrationBuilder.CreateTable(
                name: "StatusRazmjene",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StatusRazmjene", x => x.ID);
                });

            migrationBuilder.CreateTable(
                name: "Uloga",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Uloga", x => x.ID);
                });

            migrationBuilder.CreateTable(
                name: "Korisnik",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Prezime = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Telefon = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    KorisnickoIme = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LozinkaHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LozinkaSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    BrojKupovina = table.Column<int>(type: "int", nullable: true),
                    BrojRazmjena = table.Column<int>(type: "int", nullable: true),
                    BrojAktivnihArtikala = table.Column<int>(type: "int", nullable: true),
                    Adresa = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    GradID = table.Column<int>(type: "int", nullable: true),
                    UlogaID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Korisnik", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Korisnik_Grad",
                        column: x => x.GradID,
                        principalTable: "Grad",
                        principalColumn: "ID");
                    table.ForeignKey(
                        name: "FK_Korisnik_Uloga",
                        column: x => x.UlogaID,
                        principalTable: "Uloga",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateTable(
                name: "Proizvod",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Cijena = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    StanjeNovo = table.Column<bool>(type: "bit", nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    StatusProizvodaID = table.Column<int>(type: "int", nullable: true),
                    KategorijaProizvodaID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Proizvod", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Proizvod_KategorijaProizvoda",
                        column: x => x.KategorijaProizvodaID,
                        principalTable: "KategorijaProizvoda",
                        principalColumn: "ID");
                    table.ForeignKey(
                        name: "FK_Proizvod_Korisnik",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "ID");
                    table.ForeignKey(
                        name: "FK_Proizvod_StatusProizvoda",
                        column: x => x.StatusProizvodaID,
                        principalTable: "StatusProizvoda",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateTable(
                name: "Kupovina",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Datum = table.Column<DateTime>(type: "datetime2", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true),
                    ProizvodID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Kupovina", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Kupovina_Korisnik",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "ID");
                    table.ForeignKey(
                        name: "FK_Kupovina_Proizvod",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvod",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateTable(
                name: "Ocjena",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ocjena = table.Column<int>(type: "int", nullable: true),
                    Datum = table.Column<DateTime>(type: "datetime2", nullable: true),
                    ProizvodID = table.Column<int>(type: "int", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Ocjena", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Ocjena_Korisnik",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "ID");
                    table.ForeignKey(
                        name: "FK_Ocjena_Proizvod",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvod",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateTable(
                name: "Razmjena",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Datum = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Proizvod1ID = table.Column<int>(type: "int", nullable: true),
                    Proizvod2ID = table.Column<int>(type: "int", nullable: true),
                    StatusRazmjeneID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Razmjena", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Razmjena_Proizvod",
                        column: x => x.Proizvod1ID,
                        principalTable: "Proizvod",
                        principalColumn: "ID");
                    table.ForeignKey(
                        name: "FK_Razmjena_Proizvod1",
                        column: x => x.Proizvod2ID,
                        principalTable: "Proizvod",
                        principalColumn: "ID");
                    table.ForeignKey(
                        name: "FK_Razmjena_StatusRazmjene",
                        column: x => x.StatusRazmjeneID,
                        principalTable: "StatusRazmjene",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Korisnik_GradID",
                table: "Korisnik",
                column: "GradID");

            migrationBuilder.CreateIndex(
                name: "IX_Korisnik_UlogaID",
                table: "Korisnik",
                column: "UlogaID");

            migrationBuilder.CreateIndex(
                name: "IX_Kupovina_KorisnikID",
                table: "Kupovina",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Kupovina_ProizvodID",
                table: "Kupovina",
                column: "ProizvodID");

            migrationBuilder.CreateIndex(
                name: "IX_Ocjena_KorisnikID",
                table: "Ocjena",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Ocjena_ProizvodID",
                table: "Ocjena",
                column: "ProizvodID");

            migrationBuilder.CreateIndex(
                name: "IX_Proizvod_KategorijaProizvodaID",
                table: "Proizvod",
                column: "KategorijaProizvodaID");

            migrationBuilder.CreateIndex(
                name: "IX_Proizvod_KorisnikID",
                table: "Proizvod",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Proizvod_StatusProizvodaID",
                table: "Proizvod",
                column: "StatusProizvodaID");

            migrationBuilder.CreateIndex(
                name: "IX_Razmjena_Proizvod1ID",
                table: "Razmjena",
                column: "Proizvod1ID");

            migrationBuilder.CreateIndex(
                name: "IX_Razmjena_Proizvod2ID",
                table: "Razmjena",
                column: "Proizvod2ID");

            migrationBuilder.CreateIndex(
                name: "IX_Razmjena_StatusRazmjeneID",
                table: "Razmjena",
                column: "StatusRazmjeneID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Kupovina");

            migrationBuilder.DropTable(
                name: "Ocjena");

            migrationBuilder.DropTable(
                name: "Razmjena");

            migrationBuilder.DropTable(
                name: "Proizvod");

            migrationBuilder.DropTable(
                name: "StatusRazmjene");

            migrationBuilder.DropTable(
                name: "KategorijaProizvoda");

            migrationBuilder.DropTable(
                name: "Korisnik");

            migrationBuilder.DropTable(
                name: "StatusProizvoda");

            migrationBuilder.DropTable(
                name: "Grad");

            migrationBuilder.DropTable(
                name: "Uloga");
        }
    }
}
