using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eZamjena.Services.Migrations
{
    /// <inheritdoc />
    public partial class NewTables : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "ListaZeljas",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ListaZeljas", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ListaZeljas_Korisnik_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "NotifikacijaProizvods",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    ProizvodId = table.Column<int>(type: "int", nullable: false),
                    VrijemeKreiranja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Poruka = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NotifikacijaProizvods", x => x.Id);
                    table.ForeignKey(
                        name: "FK_NotifikacijaProizvods_Korisnik_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_NotifikacijaProizvods_Proizvod_ProizvodId",
                        column: x => x.ProizvodId,
                        principalTable: "Proizvod",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ListaZeljaProizvods",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ListaZeljaId = table.Column<int>(type: "int", nullable: false),
                    ProizvodId = table.Column<int>(type: "int", nullable: false),
                    VrijemeDodavanja = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ListaZeljaProizvods", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ListaZeljaProizvods_ListaZeljas_ListaZeljaId",
                        column: x => x.ListaZeljaId,
                        principalTable: "ListaZeljas",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ListaZeljaProizvods_Proizvod_ProizvodId",
                        column: x => x.ProizvodId,
                        principalTable: "Proizvod",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ListaZeljaProizvods_ListaZeljaId",
                table: "ListaZeljaProizvods",
                column: "ListaZeljaId");

            migrationBuilder.CreateIndex(
                name: "IX_ListaZeljaProizvods_ProizvodId",
                table: "ListaZeljaProizvods",
                column: "ProizvodId");

            migrationBuilder.CreateIndex(
                name: "IX_ListaZeljas_KorisnikId",
                table: "ListaZeljas",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_NotifikacijaProizvods_KorisnikId",
                table: "NotifikacijaProizvods",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_NotifikacijaProizvods_ProizvodId",
                table: "NotifikacijaProizvods",
                column: "ProizvodId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ListaZeljaProizvods");

            migrationBuilder.DropTable(
                name: "NotifikacijaProizvods");

            migrationBuilder.DropTable(
                name: "ListaZeljas");
        }
    }
}
