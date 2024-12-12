using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eZamjena.Services.Migrations
{
    /// <inheritdoc />
    public partial class RenameTables : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ListaZeljaProizvods_ListaZeljas_ListaZeljaId",
                table: "ListaZeljaProizvods");

            migrationBuilder.DropForeignKey(
                name: "FK_ListaZeljaProizvods_Proizvod_ProizvodId",
                table: "ListaZeljaProizvods");

            migrationBuilder.DropForeignKey(
                name: "FK_ListaZeljas_Korisnik_KorisnikId",
                table: "ListaZeljas");

            migrationBuilder.DropForeignKey(
                name: "FK_NotifikacijaProizvods_Korisnik_KorisnikId",
                table: "NotifikacijaProizvods");

            migrationBuilder.DropForeignKey(
                name: "FK_NotifikacijaProizvods_Proizvod_ProizvodId",
                table: "NotifikacijaProizvods");

            migrationBuilder.DropPrimaryKey(
                name: "PK_NotifikacijaProizvods",
                table: "NotifikacijaProizvods");

            migrationBuilder.DropPrimaryKey(
                name: "PK_ListaZeljas",
                table: "ListaZeljas");

            migrationBuilder.DropPrimaryKey(
                name: "PK_ListaZeljaProizvods",
                table: "ListaZeljaProizvods");

            migrationBuilder.RenameTable(
                name: "NotifikacijaProizvods",
                newName: "NotifikacijaProizvod");

            migrationBuilder.RenameTable(
                name: "ListaZeljas",
                newName: "ListaZelja");

            migrationBuilder.RenameTable(
                name: "ListaZeljaProizvods",
                newName: "ListaZeljaProizvod");

            migrationBuilder.RenameIndex(
                name: "IX_NotifikacijaProizvods_ProizvodId",
                table: "NotifikacijaProizvod",
                newName: "IX_NotifikacijaProizvod_ProizvodId");

            migrationBuilder.RenameIndex(
                name: "IX_NotifikacijaProizvods_KorisnikId",
                table: "NotifikacijaProizvod",
                newName: "IX_NotifikacijaProizvod_KorisnikId");

            migrationBuilder.RenameIndex(
                name: "IX_ListaZeljas_KorisnikId",
                table: "ListaZelja",
                newName: "IX_ListaZelja_KorisnikId");

            migrationBuilder.RenameIndex(
                name: "IX_ListaZeljaProizvods_ProizvodId",
                table: "ListaZeljaProizvod",
                newName: "IX_ListaZeljaProizvod_ProizvodId");

            migrationBuilder.RenameIndex(
                name: "IX_ListaZeljaProizvods_ListaZeljaId",
                table: "ListaZeljaProizvod",
                newName: "IX_ListaZeljaProizvod_ListaZeljaId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_NotifikacijaProizvod",
                table: "NotifikacijaProizvod",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_ListaZelja",
                table: "ListaZelja",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_ListaZeljaProizvod",
                table: "ListaZeljaProizvod",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_ListaZelja_Korisnik_KorisnikId",
                table: "ListaZelja",
                column: "KorisnikId",
                principalTable: "Korisnik",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_ListaZeljaProizvod_ListaZelja_ListaZeljaId",
                table: "ListaZeljaProizvod",
                column: "ListaZeljaId",
                principalTable: "ListaZelja",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_ListaZeljaProizvod_Proizvod_ProizvodId",
                table: "ListaZeljaProizvod",
                column: "ProizvodId",
                principalTable: "Proizvod",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_NotifikacijaProizvod_Korisnik_KorisnikId",
                table: "NotifikacijaProizvod",
                column: "KorisnikId",
                principalTable: "Korisnik",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_NotifikacijaProizvod_Proizvod_ProizvodId",
                table: "NotifikacijaProizvod",
                column: "ProizvodId",
                principalTable: "Proizvod",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ListaZelja_Korisnik_KorisnikId",
                table: "ListaZelja");

            migrationBuilder.DropForeignKey(
                name: "FK_ListaZeljaProizvod_ListaZelja_ListaZeljaId",
                table: "ListaZeljaProizvod");

            migrationBuilder.DropForeignKey(
                name: "FK_ListaZeljaProizvod_Proizvod_ProizvodId",
                table: "ListaZeljaProizvod");

            migrationBuilder.DropForeignKey(
                name: "FK_NotifikacijaProizvod_Korisnik_KorisnikId",
                table: "NotifikacijaProizvod");

            migrationBuilder.DropForeignKey(
                name: "FK_NotifikacijaProizvod_Proizvod_ProizvodId",
                table: "NotifikacijaProizvod");

            migrationBuilder.DropPrimaryKey(
                name: "PK_NotifikacijaProizvod",
                table: "NotifikacijaProizvod");

            migrationBuilder.DropPrimaryKey(
                name: "PK_ListaZeljaProizvod",
                table: "ListaZeljaProizvod");

            migrationBuilder.DropPrimaryKey(
                name: "PK_ListaZelja",
                table: "ListaZelja");

            migrationBuilder.RenameTable(
                name: "NotifikacijaProizvod",
                newName: "NotifikacijaProizvods");

            migrationBuilder.RenameTable(
                name: "ListaZeljaProizvod",
                newName: "ListaZeljaProizvods");

            migrationBuilder.RenameTable(
                name: "ListaZelja",
                newName: "ListaZeljas");

            migrationBuilder.RenameIndex(
                name: "IX_NotifikacijaProizvod_ProizvodId",
                table: "NotifikacijaProizvods",
                newName: "IX_NotifikacijaProizvods_ProizvodId");

            migrationBuilder.RenameIndex(
                name: "IX_NotifikacijaProizvod_KorisnikId",
                table: "NotifikacijaProizvods",
                newName: "IX_NotifikacijaProizvods_KorisnikId");

            migrationBuilder.RenameIndex(
                name: "IX_ListaZeljaProizvod_ProizvodId",
                table: "ListaZeljaProizvods",
                newName: "IX_ListaZeljaProizvods_ProizvodId");

            migrationBuilder.RenameIndex(
                name: "IX_ListaZeljaProizvod_ListaZeljaId",
                table: "ListaZeljaProizvods",
                newName: "IX_ListaZeljaProizvods_ListaZeljaId");

            migrationBuilder.RenameIndex(
                name: "IX_ListaZelja_KorisnikId",
                table: "ListaZeljas",
                newName: "IX_ListaZeljas_KorisnikId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_NotifikacijaProizvods",
                table: "NotifikacijaProizvods",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_ListaZeljaProizvods",
                table: "ListaZeljaProizvods",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_ListaZeljas",
                table: "ListaZeljas",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_ListaZeljaProizvods_ListaZeljas_ListaZeljaId",
                table: "ListaZeljaProizvods",
                column: "ListaZeljaId",
                principalTable: "ListaZeljas",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_ListaZeljaProizvods_Proizvod_ProizvodId",
                table: "ListaZeljaProizvods",
                column: "ProizvodId",
                principalTable: "Proizvod",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_ListaZeljas_Korisnik_KorisnikId",
                table: "ListaZeljas",
                column: "KorisnikId",
                principalTable: "Korisnik",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_NotifikacijaProizvods_Korisnik_KorisnikId",
                table: "NotifikacijaProizvods",
                column: "KorisnikId",
                principalTable: "Korisnik",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_NotifikacijaProizvods_Proizvod_ProizvodId",
                table: "NotifikacijaProizvods",
                column: "ProizvodId",
                principalTable: "Proizvod",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
