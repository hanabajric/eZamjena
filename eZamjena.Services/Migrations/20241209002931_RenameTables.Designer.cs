﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using eZamjena.Services.Database;

#nullable disable

namespace eZamjena.Services.Migrations
{
    [DbContext(typeof(Ib190019Context))]
    [Migration("20241209002931_RenameTables")]
    partial class RenameTables
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "7.0.0-preview.7.22376.2")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("eZamjena.Services.Database.Grad", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("ID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("Naziv")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("Grad", (string)null);
                });

            modelBuilder.Entity("eZamjena.Services.Database.KategorijaProizvodum", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("ID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("KategorijaProizvoda");
                });

            modelBuilder.Entity("eZamjena.Services.Database.Korisnik", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("ID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("Adresa")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int?>("BrojAktivnihArtikala")
                        .HasColumnType("int");

                    b.Property<int?>("BrojKupovina")
                        .HasColumnType("int");

                    b.Property<int?>("BrojRazmjena")
                        .HasColumnType("int");

                    b.Property<string>("Email")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int?>("GradId")
                        .HasColumnType("int")
                        .HasColumnName("GradID");

                    b.Property<string>("Ime")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("KorisnickoIme")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("LozinkaHash")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("LozinkaSalt")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Prezime")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<byte[]>("Slika")
                        .HasColumnType("varbinary(max)");

                    b.Property<string>("Telefon")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int?>("UlogaId")
                        .HasColumnType("int")
                        .HasColumnName("UlogaID");

                    b.HasKey("Id");

                    b.HasIndex("GradId");

                    b.HasIndex("UlogaId");

                    b.ToTable("Korisnik", (string)null);
                });

            modelBuilder.Entity("eZamjena.Services.Database.Kupovina", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("ID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<DateTime?>("Datum")
                        .HasColumnType("datetime2");

                    b.Property<int?>("KorisnikId")
                        .HasColumnType("int")
                        .HasColumnName("KorisnikID");

                    b.Property<int?>("ProizvodId")
                        .HasColumnType("int")
                        .HasColumnName("ProizvodID");

                    b.HasKey("Id");

                    b.HasIndex("KorisnikId");

                    b.HasIndex("ProizvodId");

                    b.ToTable("Kupovina", (string)null);
                });

            modelBuilder.Entity("eZamjena.Services.Database.ListaZelja", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<DateTime>("CreatedAt")
                        .HasColumnType("datetime2");

                    b.Property<int>("KorisnikId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("KorisnikId");

                    b.ToTable("ListaZelja", (string)null);
                });

            modelBuilder.Entity("eZamjena.Services.Database.ListaZeljaProizvod", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<int>("ListaZeljaId")
                        .HasColumnType("int");

                    b.Property<int>("ProizvodId")
                        .HasColumnType("int");

                    b.Property<DateTime>("VrijemeDodavanja")
                        .HasColumnType("datetime2");

                    b.HasKey("Id");

                    b.HasIndex("ListaZeljaId");

                    b.HasIndex("ProizvodId");

                    b.ToTable("ListaZeljaProizvod", (string)null);
                });

            modelBuilder.Entity("eZamjena.Services.Database.NotifikacijaProizvod", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<int>("KorisnikId")
                        .HasColumnType("int");

                    b.Property<string>("Poruka")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("ProizvodId")
                        .HasColumnType("int");

                    b.Property<DateTime>("VrijemeKreiranja")
                        .HasColumnType("datetime2");

                    b.HasKey("Id");

                    b.HasIndex("KorisnikId");

                    b.HasIndex("ProizvodId");

                    b.ToTable("NotifikacijaProizvod", (string)null);
                });

            modelBuilder.Entity("eZamjena.Services.Database.Ocjena", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("ID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<DateTime?>("Datum")
                        .HasColumnType("datetime2");

                    b.Property<int?>("KorisnikId")
                        .HasColumnType("int")
                        .HasColumnName("KorisnikID");

                    b.Property<int?>("Ocjena1")
                        .HasColumnType("int")
                        .HasColumnName("Ocjena");

                    b.Property<int?>("ProizvodId")
                        .HasColumnType("int")
                        .HasColumnName("ProizvodID");

                    b.HasKey("Id");

                    b.HasIndex("KorisnikId");

                    b.HasIndex("ProizvodId");

                    b.ToTable("Ocjena", (string)null);
                });

            modelBuilder.Entity("eZamjena.Services.Database.Proizvod", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("ID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<decimal>("Cijena")
                        .HasColumnType("decimal(18,2)");

                    b.Property<int?>("KategorijaProizvodaId")
                        .HasColumnType("int")
                        .HasColumnName("KategorijaProizvodaID");

                    b.Property<int>("KorisnikId")
                        .HasColumnType("int")
                        .HasColumnName("KorisnikID");

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Opis")
                        .HasColumnType("nvarchar(max)");

                    b.Property<byte[]>("Slika")
                        .HasColumnType("varbinary(max)");

                    b.Property<bool>("StanjeNovo")
                        .HasColumnType("bit");

                    b.Property<int?>("StatusProizvodaId")
                        .HasColumnType("int")
                        .HasColumnName("StatusProizvodaID");

                    b.HasKey("Id");

                    b.HasIndex("KategorijaProizvodaId");

                    b.HasIndex("KorisnikId");

                    b.HasIndex("StatusProizvodaId");

                    b.ToTable("Proizvod", (string)null);
                });

            modelBuilder.Entity("eZamjena.Services.Database.Razmjena", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("ID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<DateTime?>("Datum")
                        .HasColumnType("datetime2");

                    b.Property<int?>("Proizvod1Id")
                        .HasColumnType("int")
                        .HasColumnName("Proizvod1ID");

                    b.Property<int?>("Proizvod2Id")
                        .HasColumnType("int")
                        .HasColumnName("Proizvod2ID");

                    b.Property<int?>("StatusRazmjeneId")
                        .HasColumnType("int")
                        .HasColumnName("StatusRazmjeneID");

                    b.HasKey("Id");

                    b.HasIndex("Proizvod1Id");

                    b.HasIndex("Proizvod2Id");

                    b.HasIndex("StatusRazmjeneId");

                    b.ToTable("Razmjena", (string)null);
                });

            modelBuilder.Entity("eZamjena.Services.Database.StatusProizvodum", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("ID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("Naziv")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("StatusProizvoda");
                });

            modelBuilder.Entity("eZamjena.Services.Database.StatusRazmjene", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("ID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("Naziv")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("StatusRazmjene", (string)null);
                });

            modelBuilder.Entity("eZamjena.Services.Database.Uloga", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("ID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("Naziv")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("Uloga", (string)null);
                });

            modelBuilder.Entity("eZamjena.Services.Database.Korisnik", b =>
                {
                    b.HasOne("eZamjena.Services.Database.Grad", "Grad")
                        .WithMany("Korisniks")
                        .HasForeignKey("GradId")
                        .HasConstraintName("FK_Korisnik_Grad");

                    b.HasOne("eZamjena.Services.Database.Uloga", "Uloga")
                        .WithMany("Korisniks")
                        .HasForeignKey("UlogaId")
                        .HasConstraintName("FK_Korisnik_Uloga");

                    b.Navigation("Grad");

                    b.Navigation("Uloga");
                });

            modelBuilder.Entity("eZamjena.Services.Database.Kupovina", b =>
                {
                    b.HasOne("eZamjena.Services.Database.Korisnik", "Korisnik")
                        .WithMany("Kupovinas")
                        .HasForeignKey("KorisnikId")
                        .HasConstraintName("FK_Kupovina_Korisnik");

                    b.HasOne("eZamjena.Services.Database.Proizvod", "Proizvod")
                        .WithMany("Kupovinas")
                        .HasForeignKey("ProizvodId")
                        .HasConstraintName("FK_Kupovina_Proizvod");

                    b.Navigation("Korisnik");

                    b.Navigation("Proizvod");
                });

            modelBuilder.Entity("eZamjena.Services.Database.ListaZelja", b =>
                {
                    b.HasOne("eZamjena.Services.Database.Korisnik", "Korisnik")
                        .WithMany()
                        .HasForeignKey("KorisnikId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Korisnik");
                });

            modelBuilder.Entity("eZamjena.Services.Database.ListaZeljaProizvod", b =>
                {
                    b.HasOne("eZamjena.Services.Database.ListaZelja", "ListaZelja")
                        .WithMany("ListaZeljaProizvods")
                        .HasForeignKey("ListaZeljaId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("eZamjena.Services.Database.Proizvod", "Proizvod")
                        .WithMany("ListaZeljaProizvods")
                        .HasForeignKey("ProizvodId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("ListaZelja");

                    b.Navigation("Proizvod");
                });

            modelBuilder.Entity("eZamjena.Services.Database.NotifikacijaProizvod", b =>
                {
                    b.HasOne("eZamjena.Services.Database.Korisnik", "Korisnik")
                        .WithMany("NotifikacijeProizvods")
                        .HasForeignKey("KorisnikId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("eZamjena.Services.Database.Proizvod", "Proizvod")
                        .WithMany("NotifikacijeProizvods")
                        .HasForeignKey("ProizvodId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Korisnik");

                    b.Navigation("Proizvod");
                });

            modelBuilder.Entity("eZamjena.Services.Database.Ocjena", b =>
                {
                    b.HasOne("eZamjena.Services.Database.Korisnik", "Korisnik")
                        .WithMany("Ocjenas")
                        .HasForeignKey("KorisnikId")
                        .HasConstraintName("FK_Ocjena_Korisnik");

                    b.HasOne("eZamjena.Services.Database.Proizvod", "Proizvod")
                        .WithMany("Ocjenas")
                        .HasForeignKey("ProizvodId")
                        .HasConstraintName("FK_Ocjena_Proizvod");

                    b.Navigation("Korisnik");

                    b.Navigation("Proizvod");
                });

            modelBuilder.Entity("eZamjena.Services.Database.Proizvod", b =>
                {
                    b.HasOne("eZamjena.Services.Database.KategorijaProizvodum", "KategorijaProizvoda")
                        .WithMany("Proizvods")
                        .HasForeignKey("KategorijaProizvodaId")
                        .HasConstraintName("FK_Proizvod_KategorijaProizvoda");

                    b.HasOne("eZamjena.Services.Database.Korisnik", "Korisnik")
                        .WithMany("Proizvods")
                        .HasForeignKey("KorisnikId")
                        .IsRequired()
                        .HasConstraintName("FK_Proizvod_Korisnik");

                    b.HasOne("eZamjena.Services.Database.StatusProizvodum", "StatusProizvoda")
                        .WithMany("Proizvods")
                        .HasForeignKey("StatusProizvodaId")
                        .HasConstraintName("FK_Proizvod_StatusProizvoda");

                    b.Navigation("KategorijaProizvoda");

                    b.Navigation("Korisnik");

                    b.Navigation("StatusProizvoda");
                });

            modelBuilder.Entity("eZamjena.Services.Database.Razmjena", b =>
                {
                    b.HasOne("eZamjena.Services.Database.Proizvod", "Proizvod1")
                        .WithMany("RazmjenaProizvod1s")
                        .HasForeignKey("Proizvod1Id")
                        .HasConstraintName("FK_Razmjena_Proizvod");

                    b.HasOne("eZamjena.Services.Database.Proizvod", "Proizvod2")
                        .WithMany("RazmjenaProizvod2s")
                        .HasForeignKey("Proizvod2Id")
                        .HasConstraintName("FK_Razmjena_Proizvod1");

                    b.HasOne("eZamjena.Services.Database.StatusRazmjene", "StatusRazmjene")
                        .WithMany("Razmjenas")
                        .HasForeignKey("StatusRazmjeneId")
                        .HasConstraintName("FK_Razmjena_StatusRazmjene");

                    b.Navigation("Proizvod1");

                    b.Navigation("Proizvod2");

                    b.Navigation("StatusRazmjene");
                });

            modelBuilder.Entity("eZamjena.Services.Database.Grad", b =>
                {
                    b.Navigation("Korisniks");
                });

            modelBuilder.Entity("eZamjena.Services.Database.KategorijaProizvodum", b =>
                {
                    b.Navigation("Proizvods");
                });

            modelBuilder.Entity("eZamjena.Services.Database.Korisnik", b =>
                {
                    b.Navigation("Kupovinas");

                    b.Navigation("NotifikacijeProizvods");

                    b.Navigation("Ocjenas");

                    b.Navigation("Proizvods");
                });

            modelBuilder.Entity("eZamjena.Services.Database.ListaZelja", b =>
                {
                    b.Navigation("ListaZeljaProizvods");
                });

            modelBuilder.Entity("eZamjena.Services.Database.Proizvod", b =>
                {
                    b.Navigation("Kupovinas");

                    b.Navigation("ListaZeljaProizvods");

                    b.Navigation("NotifikacijeProizvods");

                    b.Navigation("Ocjenas");

                    b.Navigation("RazmjenaProizvod1s");

                    b.Navigation("RazmjenaProizvod2s");
                });

            modelBuilder.Entity("eZamjena.Services.Database.StatusProizvodum", b =>
                {
                    b.Navigation("Proizvods");
                });

            modelBuilder.Entity("eZamjena.Services.Database.StatusRazmjene", b =>
                {
                    b.Navigation("Razmjenas");
                });

            modelBuilder.Entity("eZamjena.Services.Database.Uloga", b =>
                {
                    b.Navigation("Korisniks");
                });
#pragma warning restore 612, 618
        }
    }
}