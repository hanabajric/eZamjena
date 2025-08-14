using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eZamjena.Services.Migrations
{
    /// <inheritdoc />
    public partial class AddPrijava : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Prijava",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ProizvodID = table.Column<int>(type: "int", nullable: false),
                    PrijavioKorisnikID = table.Column<int>(type: "int", nullable: false),
                    Razlog = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Poruka = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    Datum = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "GETDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Prijava", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Prijava_Korisnik",
                        column: x => x.PrijavioKorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "ID");
                    table.ForeignKey(
                        name: "FK_Prijava_Proizvod",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvod",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Prijava_PrijavioKorisnikID",
                table: "Prijava",
                column: "PrijavioKorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Prijava_ProizvodID",
                table: "Prijava",
                column: "ProizvodID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Prijava");
        }
    }
}
