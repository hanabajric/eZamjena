using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.Extensions.Configuration;


namespace eZamjena.Services.Database
{
    public partial class Ib190019Context : DbContext
    {
        private readonly IConfiguration _configuration;
        public Ib190019Context(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public Ib190019Context(DbContextOptions<Ib190019Context> options, IConfiguration configuration)
            : base(options)
        {
            _configuration = configuration;
        }

        public virtual DbSet<Grad> Grads { get; set; } = null!;
        public virtual DbSet<KategorijaProizvodum> KategorijaProizvoda { get; set; } = null!;
        public virtual DbSet<Korisnik> Korisniks { get; set; } = null!;
        public virtual DbSet<Kupovina> Kupovinas { get; set; } = null!;
        public virtual DbSet<Ocjena> Ocjenas { get; set; } = null!;
        public virtual DbSet<Proizvod> Proizvods { get; set; } = null!;
        public virtual DbSet<Razmjena> Razmjenas { get; set; } = null!;
        public virtual DbSet<StatusProizvodum> StatusProizvoda { get; set; } = null!;
        public virtual DbSet<StatusRazmjene> StatusRazmjenes { get; set; } = null!;
        public virtual DbSet<Uloga> Ulogas { get; set; } = null!;

        //protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        //{
        //    if (!optionsBuilder.IsConfigured)
        //    {
        //        var connectionString = _configuration.GetConnectionString("DefaultConnection");
        //        optionsBuilder.UseSqlServer(connectionString);
        //    }
        //}
//        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
//        {
//            if (!optionsBuilder.IsConfigured)
//            {
//#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
//                optionsBuilder.UseSqlServer("Data Source=(local)\\mssqlserver_olap;Initial Catalog=IB190019;Integrated Security=True;");
//            }
//        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Grad>(entity =>
            {
                entity.ToTable("Grad");

                entity.Property(e => e.Id)
                    
                    .HasColumnName("ID");
            });

            modelBuilder.Entity<KategorijaProizvodum>(entity =>
            {
                entity.Property(e => e.Id)
                    .HasColumnName("ID");
            });

            modelBuilder.Entity<Korisnik>(entity =>
            {
                entity.ToTable("Korisnik");

                entity.Property(e => e.Id)
                    .HasColumnName("ID");

                entity.Property(e => e.GradId).HasColumnName("GradID");

                entity.Property(e => e.UlogaId).HasColumnName("UlogaID");

                entity.HasOne(d => d.Grad)
                    .WithMany(p => p.Korisniks)
                    .HasForeignKey(d => d.GradId)
                    .HasConstraintName("FK_Korisnik_Grad");

                entity.HasOne(d => d.Uloga)
                    .WithMany(p => p.Korisniks)
                    .HasForeignKey(d => d.UlogaId)
                    .HasConstraintName("FK_Korisnik_Uloga");
            });

            modelBuilder.Entity<Kupovina>(entity =>
            {
                entity.ToTable("Kupovina");

                entity.Property(e => e.Id)
                    .HasColumnName("ID");

                entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

                entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Kupovinas)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK_Kupovina_Korisnik");

                entity.HasOne(d => d.Proizvod)
                    .WithMany(p => p.Kupovinas)
                    .HasForeignKey(d => d.ProizvodId)
                    .HasConstraintName("FK_Kupovina_Proizvod");
            });

            modelBuilder.Entity<Ocjena>(entity =>
            {
                entity.ToTable("Ocjena");

                entity.Property(e => e.Id)
                    .HasColumnName("ID");

                entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

                entity.Property(e => e.Ocjena1).HasColumnName("Ocjena");

                entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Ocjenas)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK_Ocjena_Korisnik");

                entity.HasOne(d => d.Proizvod)
                    .WithMany(p => p.Ocjenas)
                    .HasForeignKey(d => d.ProizvodId)
                    .HasConstraintName("FK_Ocjena_Proizvod");
            });

            modelBuilder.Entity<Proizvod>(entity =>
            {
                entity.ToTable("Proizvod");

                entity.Property(e => e.Id)
                    .HasColumnName("ID");

                entity.Property(e => e.KategorijaProizvodaId).HasColumnName("KategorijaProizvodaID");

                entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

                entity.Property(e => e.StatusProizvodaId).HasColumnName("StatusProizvodaID");
                entity.Property(e => e.Cijena)
        .HasColumnType("decimal(18,2)");

                entity.HasOne(d => d.KategorijaProizvoda)
                    .WithMany(p => p.Proizvods)
                    .HasForeignKey(d => d.KategorijaProizvodaId)
                    .HasConstraintName("FK_Proizvod_KategorijaProizvoda");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Proizvods)
                    .HasForeignKey(d => d.KorisnikId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Proizvod_Korisnik");

                entity.HasOne(d => d.StatusProizvoda)
                    .WithMany(p => p.Proizvods)
                    .HasForeignKey(d => d.StatusProizvodaId)
                    .HasConstraintName("FK_Proizvod_StatusProizvoda");
            });

            modelBuilder.Entity<Razmjena>(entity =>
            {
                entity.ToTable("Razmjena");

                entity.Property(e => e.Id)
                    .HasColumnName("ID");

                entity.Property(e => e.Proizvod1Id).HasColumnName("Proizvod1ID");

                entity.Property(e => e.Proizvod2Id).HasColumnName("Proizvod2ID");

                entity.Property(e => e.StatusRazmjeneId).HasColumnName("StatusRazmjeneID");

                entity.HasOne(d => d.Proizvod1)
                    .WithMany(p => p.RazmjenaProizvod1s)
                    .HasForeignKey(d => d.Proizvod1Id)
                    .HasConstraintName("FK_Razmjena_Proizvod");

                entity.HasOne(d => d.Proizvod2)
                    .WithMany(p => p.RazmjenaProizvod2s)
                    .HasForeignKey(d => d.Proizvod2Id)
                    .HasConstraintName("FK_Razmjena_Proizvod1");

                entity.HasOne(d => d.StatusRazmjene)
                    .WithMany(p => p.Razmjenas)
                    .HasForeignKey(d => d.StatusRazmjeneId)
                    .HasConstraintName("FK_Razmjena_StatusRazmjene");
            });

            modelBuilder.Entity<StatusProizvodum>(entity =>
            {
                entity.Property(e => e.Id)
                    .HasColumnName("ID");
            });

            modelBuilder.Entity<StatusRazmjene>(entity =>
            {
                entity.ToTable("StatusRazmjene");

                entity.Property(e => e.Id)
                    .HasColumnName("ID");
            });

            modelBuilder.Entity<Uloga>(entity =>
            {
                entity.ToTable("Uloga");

                entity.Property(e => e.Id)
                    .HasColumnName("ID");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
