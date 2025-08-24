using AutoMapper;
using eZamjena.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eZamjena.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile(){
            CreateMap<Database.Korisnik,Model.Korisnik>();
            CreateMap<KorisnikInsertRequest, Database.Korisnik>();
            CreateMap<KorisnikUpdateRequest, Database.Korisnik>()
               .ForAllMembers(opt =>
               opt.Condition((src, dest, srcMember) => srcMember != null));

            CreateMap<AdminKorisnikUpdateRequest, Database.Korisnik>().ForMember(dest => dest.LozinkaHash, opt => opt.Ignore())  // Ignoriraj hash lozinke
                .ForMember(dest => dest.LozinkaSalt, opt => opt.Ignore()); ;

            CreateMap<Database.Uloga, Model.Uloga>();

            CreateMap<Database.Proizvod, Model.Proizvod>()
          .ForMember(dest => dest.NazivKategorijeProizvoda, opt => opt.MapFrom(src => src.KategorijaProizvoda != null ? src.KategorijaProizvoda.Naziv : "Nepoznato"))
          .ForMember(dest => dest.NazivKorisnika, opt => opt.MapFrom(src => src.Korisnik != null ? src.Korisnik.KorisnickoIme : "Nepoznato"))
        ;


            CreateMap<ProizvodUpsertRequest, Database.Proizvod>();
            CreateMap<KupovinaUpsertRequest, Database.Kupovina>();

            CreateMap<Database.KategorijaProizvodum, Model.KategorijaProizvodum>();
            CreateMap<KategorijaProizvodumUpsertRequest, Database.KategorijaProizvodum>();


            CreateMap<Database.StatusProizvodum, Model.StatusProizvodum>();
            CreateMap<StatusProizvodumUpsertRequest, Database.StatusProizvodum>();


            CreateMap<Database.Ocjena, Model.Ocjena>();
            CreateMap<OcjenaUpsertRequest, Database.Ocjena>();

            CreateMap<Database.Razmjena, Model.Razmjena>();
            CreateMap<RazmjenaUpsertRequest, Database.Razmjena>();

            CreateMap<Database.Kupovina, Model.Kupovina>();
            CreateMap<KupovinaUpsertRequest, Database.Kupovina>();

            CreateMap<Database.StatusRazmjene, Model.StatusRazmjene>();
            CreateMap<StatusRazmjeneUpsertRequest, Database.StatusRazmjene>();

            CreateMap<Database.Uloga, Model.Uloga>();
            CreateMap<UlogaUpsertRequest, Database.Uloga>();

            CreateMap<Database.Grad, Model.Grad>();
            CreateMap<GradUpsertRequest, Database.Grad>();

            CreateMap<Database.ListaZelja, Model.ListaZelja>();
            CreateMap<ListaZeljaUpsertRequest, Database.ListaZelja>();
 

            CreateMap<Database.ListaZeljaProizvod, Model.ListaZeljaProizvod>();
            CreateMap<ListaZeljaProizvodUpsertRequest, Database.ListaZeljaProizvod>();

            CreateMap<Database.NotifikacijaProizvod, Model.NotifikacijaProizvod>();
            CreateMap<NotifikacijaProizvodUpsertRequest, Database.NotifikacijaProizvod>();

            CreateMap<Database.Prijava, Model.Prijava>()
             .ForMember(d => d.ProizvodNaziv,
             opt => opt.MapFrom(s => s.Proizvod.Naziv))
            .ForMember(d => d.PrijavioKorisnik,
            opt => opt.MapFrom(s => s.PrijavioKorisnik.KorisnickoIme));
            CreateMap<PrijavaUpsertRequest, Database.Prijava>();


        }
    }
}
